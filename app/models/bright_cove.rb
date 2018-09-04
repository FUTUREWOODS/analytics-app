class BrightCove
  OAUTHU_URL = 'https://oauth.brightcove.com/v4/access_token'
  attr_accessor :account_id, :client_id, :client_secret,
                :site, :dimensions, :fields, :format, :token, :where
  def initialize(payload = {})
    @yaml = YAML.load_file('config/fields.yml')
    @account_id = payload[:account_id]
    #@dimensions = payload[:dimensions].empty? payload[:dimensions] : payload[:dimensions].join(',')
    #@fields = yaml[payload[:dimensions].first].join(',')
    @client_id = payload[:client_id]
    @client_secret = payload[:client_secret]
    @site = payload[:site]
    @where = payload[:where]
    @start_date = payload[:start_date]
    @end_date = payload[:end_date]
    client = OAuth2::Client.new(@client_id, @client_secret,
                                site: @site,
                                token_url: OAUTHU_URL)
    @token = client.client_credentials.get_token
  end

  def all_view
    fields = @yaml['date'].join(',')
    puts @where
    @token.get("/v1/data?accounts=#{@account_id}&fields=#{fields}&dimensions=date&where=#{@where}&sort=date&limit=all&from=#{@start_date}&to=#{@end_date}").body
  end

  def single
    fields = @yaml['video'].join(',')
    @token.get("/v1/data?accounts=#{@account_id}&fields=#{fields}&dimensions=video&limit=5&sort=-video_view&from=#{@start_date}&to=#{@end_date}").body
  end

  def video(id)
    @token.get("/v1/data?accounts=#{@account_id}&dimensions=date&fields=video&where=video==#{id}&from=#{@start_date}&to=#{@end_date}").body
  end

end