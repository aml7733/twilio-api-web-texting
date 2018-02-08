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
    $.getJSON('/messages/1.json', function(data) {
      renderMessages(data)
    })
  })
}

function renderMessages(response) {
  // If the number of messages already populated is equal to the number of
  // messages in the json response, no need to add HTML element.
  var numMessages = $(".text").length
  if (numMessages < response.length) {
    for (var i = numMessages; i < response.length; i++) {
      var messageObject = new Message(response[i].name, response[i].phone_number, response[i].text)
      $("#messageList").append(populateHTML(messageObject))
    }
  }
}

function populateHTML(messageObject) {
  return `<div class="messageBubble">
    <div class="name">${messageObject.name}</div>
    <div class="text">${messageObject.text}</div>
  </div>`;
}

$(document).ready(attachListener)
