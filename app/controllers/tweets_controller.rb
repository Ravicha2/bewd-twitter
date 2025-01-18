class TweetsController < ApplicationController
    def index
        @tweets = Tweet.includes(:user).order(created_at: :desc)
        render 'tweets/index'
    end
    
    def create
      token = cookies.permanent.signed[:twitter_session_token]
      session = Session.find_by(token: token)
      if session
        user = session.user
        @tweet = user.tweets.build(tweet_params)
        if @tweet.save
          render 'tweets/create', status: :created
        else
          render json: { errors: @tweet.errors.full_messages }, status: :unprocessable_entity
        end
      else
        render json: { errors: ['User not authenticated'] }, status: :unauthorized
      end
    end

    def destroy
      token = cookies.permanent.signed[:twitter_session_token]
      session = Session.find_by(token: token)
      if session
        @tweet = Tweet.find_by(id: params[:id])
        if @tweet and @tweet.destroy
          render json: {success: true}
        else
          render json: {success: false}
        end
      else 
        render json: {success: false}, status: :unauthorized
      end
    end

    def index_by_user
      user = User.find_by(username: params[:username])
      if user
        @tweets = user.tweets.order(create_at: :desc)
        render 'tweets/index_by_user'
      else
        render json: { error: 'User not found' }
      end
    end
      
  private
    def tweet_params
      params.require(:tweet).permit(:message)
    end
end
