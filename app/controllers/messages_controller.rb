class MessagesController < ApplicationController
  def new
    @message = Message.new
  end

  def create
    byebug
    @message = Message.new(params.require(:message).permit(:name, :phone_number, :text))

    if @message.save
      redirect_to (MESSAGE_SENT_PATH), alert: "Message successfully saved."
    else
      render :new
    end

  end

  def show
  end
end
