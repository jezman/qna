class SearchesController < ApplicationController
  authorize_resource

  def index
    @results = Search.find(params[:query], params[:resource])
  end
end
