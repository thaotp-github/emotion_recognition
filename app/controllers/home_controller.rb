class HomeController < ApplicationController
  def index
  end

  def create
    auth = {
      cloud_name: Rails.application.credentials.cloudinary[:cloud_name],
      api_key:    Rails.application.credentials.cloudinary[:api_key],
      api_secret: Rails.application.credentials.cloudinary[:api_secret]
    }
    upload_response = Cloudinary::Uploader.upload(params[:image], auth)

    input = {
      image: upload_response['url'],
      numResults: 7
    }

    client = Algorithmia.client(Rails.application.credentials.algorithmia[:key])
    algo = client.algo('deeplearning/EmotionRecognitionCNNMBP/1.0.1')
    response = algo.pipe(input).result
    render json: response
  end

end
