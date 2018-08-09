class HomesController < ApplicationController
  OAUTHU_URL = 'https://oauth.brightcove.com/v4/access_token'

  def new
  end

  def create
    yaml = YAML.load_file("config/fields.yml")
    account_id = params[:account_id]
    dimensions = params[:dimensions].join(',')
    fields = yaml[params[:dimensions].first].join(',')
    client = OAuth2::Client.new(params[:client_id], params[:client_secret],
                                site: params[:site],
                                token_url: OAUTHU_URL)
    token = client.client_credentials.get_token
    render json: token.get("/v1/data?accounts=#{account_id}&dimensions=#{dimensions}&fields=#{fields}&sort=date&limit=all").body
  end
end
