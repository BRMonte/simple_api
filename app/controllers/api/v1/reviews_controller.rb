class Api::V1::ReviewsController < ApplicationController
  before_action :load_book, only: :index
  before_action :load_review, only: [:show, :update, :destroy]
  before_action :authenticate_with_token!, only: [:create, :update, :destroy]

  def index
    @reviews = @book.reviews
    json_response("Index books successfully", true, {reviews: @reviews}, :ok)
  end

  def show
    json_response("Show review successfully", true, {review: @review}, :ok)
  end

  def create
    review = Review.new(review_params)
    review.user_id = current_user.id
    review.book_id = params[:book_id]

    if review.save
      json_response("Created review successfully", true, {review: review}, :ok)
    else
      json_response("Created review fail", false, {}, :unproccessable_entity)
    end
  end

  def update
    if correct_user(@review.user)
      if @review.update(review_params)
        json_response("Updated review successfully", true, {review: review}, :ok)
      else
        json_response("Updated review fail", false, {}, :unproccessable_entity)
      end
    else
      json_response("You don't have permissions", false, {}, :unauthorized)
    end
  end

  def destroy
    if correct_user(@review.user)
      if @review.update(review_params)
        json_response("Deleted review successfully", true, {}, :ok)
      else
        json_response("Deleted review fail", false, {}, :unproccessable_entity)
      end
    else
      json_response("You don't have permissions", false, {}, :unauthorized)
    end
  end

  private
  def load_book
    @book = Book.find_by(id: params[:book_id])
    unless @book.present?
      json_response("Can not find book", false, {}, :not_found)
    end
  end

  def load_review
    @review = Review.find_by(id: params[:id])
    unless @review.present?
      json_response("Cannot find the review", false, {}, :not_found)
    end
  end

  def review_params
    params.require(:review).permit(:title, :content_rating, :recommend_rating)
  end
end
