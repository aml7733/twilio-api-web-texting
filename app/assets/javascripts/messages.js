class Message {
  constructor(name, phone_number, text) {
    this.name = name
    this.phone_number = phone_number
    this.text = text
  }
}

function  attachListener() {
  $("button#refresh").on("click", function(event) {
    event.preventDefault();
    $.getJSON('/1.json', function(data) {
      debugger
      renderMessages(data)
    })
  })
}

function renderMessages(response) {
  response.messages.forEach((jsonMessage) => {
    var newMessage = new Message(jsonMessage.name, jsonMessage.phone_number, jsonMessage.text)
    $("#messageList").append(populateHTML(newMessage))
  })
}

function populateHTML(messageObject) {
  return "<br><li><%= messageObject.name %></li><li><p><%= messageObject.text %></p></li>";
}

$(document).ready(attachListener)
