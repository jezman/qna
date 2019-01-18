$ ->
  questionId = $(".question").data("id")
  
  App.cable.subscriptions.create({ channel: 'AnswersChannel', id: questionId }, {
    connected: ->
      @perform 'follow'
    ,
    received: (data) ->
      parseData = $.parseJSON(data)
      console.log(parseData.answer.body)

      if gon.current_user && (gon.current_user.id != parseData.user.id)
        $('.answers').append(JST['templates/answer']({
          answer: parseData.answer,
          user: parseData.user,
          files: parseData.files,
          links: parseData.links,
          rating: parseData.rating_sum
      }))
  })
