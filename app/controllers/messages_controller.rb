require 'twilio-ruby'
require 'global_phone'

class MessagesController < ApplicationController
  before_action :find_conversation, only: [:show]
  skip_before_action :verify_authenticity_token

  # Could have just put find_conversation logic in show action, but this allows
  # later features (edit/update/destroy) to quickly find a message.
  # protect_from_forgery line was necessary to overcome testing problem
  # where triggered get request couldn't verify CSRF token

  def new
    @message = Message.new
  end

  def create
    validate_message_params

    if @message.save
      send_text_message(@message.phone_number, @message.text)
      redirect_to message_path(@message), alert: "Message successfully sent."
    else
      render :new, alert: "There was a problem with the information you entered.  Please try again."
    end
  end

  def show

  end

  def receive_message
    # Given the nature of the assignment, I think it's not necessary now to
    # validate message params from Twilio's api.  They should be constant,
    # until the api is updated.  Validation here may be necessary in the
    # future to prevent malicious attempts to edit the database.

    body = params["Body"]
    from = params["From"]
    @conversation = Conversation.find_by(phone_number: from)
    @message = Message.new(phone_number: from, text: body, name: "Twilio Number")
    @conversation.messages << @message
    @message.save

    byebug
    ##### If confirmation of saved reply necessary #####
    # load_twilio_client
    #
    # new_message = @client.messages.create(
    #   from: ENV['TWILIO_PHONE_NUMBER'],
    #   to: number,
    #   body: "Your message has been saved.  Thank you for using this service."
    # )
  end

  private

    def find_conversation
      @message = Message.find_by(id: params[:id])
      @conversation = Conversation.find_by(phone_number: @message.phone_number)
      @messages = @conversation.messages
    end

    def validate_message_params
      @message = Message.new(params.require(:message).permit(:name, :phone_number, :text))
      @message.phone_number = GlobalPhone.normalize(@message.phone_number)      #Re-writes phone number as E.164 format, acceptable for twilio client
      @message.conversation = Conversation.find_or_create_by(phone_number: @message.phone_number)
    end

    def send_text_message(phone_number, text_message)
      load_twilio_client
      new_message = @client.messages.create(
        from: ENV['TWILIO_PHONE_NUMBER'],
        to: phone_number,
        body: text_message
      )
      #Note: send message to Twilio, guides say create line should read
      # @client.messages.account.create, but I got a no method error
    end

    def load_twilio_client
      @client = Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN'])
    end

end
