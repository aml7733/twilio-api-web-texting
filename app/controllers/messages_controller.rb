class MessagesController < ApplicationController
  def new
    @message = Message.new
  end

  def create
    @message = Message.new(params.require(:message).permit(:name, :phone_number, :text))

    if GlobalPhone.validate(@message.phone_number) && @message.save
      send(@message.phone_number, @message.text)
      redirect_to message_path(@message), alert: "Message successfully sent."
    else
      render :new, alert: "There was a problem with the information you entered.  Please try again."
    end

  end

  def show
  end

  private
    def send(phone_number, text)
      @twilio_number = ENV['TWILIO_PHONE_NUMBER']
      @client = Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN'])

      message = @client.account.messages.create(
        from: @twilio_number,
        to: phone_number,
        body: text
      )
    end
end
