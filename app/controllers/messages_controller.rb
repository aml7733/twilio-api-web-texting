require 'twilio-ruby'
require 'global_phone'

class MessagesController < ApplicationController
  before_action :find_message, only: [:show]
  #Could have just put logic in show action, but this allows later
  #features (edit/update/destroy) to quickly find a message.

  def new
    @message = Message.new
  end

  def create
    @message = Message.new(params.require(:message).permit(:name, :phone_number, :text))
    @message.phone_number = GlobalPhone.normalize(@message.phone_number)      #Re-writes phone number as E.164 format, acceptable for twilio client

    if @message.save
      # send_text_message(@message.phone_number, @message.text)
      redirect_to message_path(@message), alert: "Message successfully sent."
    else
      render :new, alert: "There was a problem with the information you entered.  Please try again."
    end
  end

  def show
  end

  private
    def send_text_message(phone_number, text_message)
      @twilio_number = ENV['TWILIO_PHONE_NUMBER']
      @client = Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN'])

      new_message = @client.messages.create(
        from: @twilio_number,
        to: phone_number,
        body: text_message
      )
      #Note: send message to Twilio, guides say line 32 should read
      # @client.messages.account.create, but I got a no method error
    end

    def find_message
      @message = Message.find_by(id: params[:id])
    end
end
