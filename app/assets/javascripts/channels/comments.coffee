$ ->
  questionId = $(".question").data("id")
  
  App.cable.subscriptions.create({ channel: 'CommentsChannel', question_id: questionId }, {
    connected: ->
      @perform 'follow'
    ,
    received: (data) ->
      dataParse = $.parseJSON(data)

      container = '.' + dataParse.resource + '-' + dataParse.id

      if gon.current_user && (gon.current_user.id != dataParse.user.id)
        $(container + ' .comments').append(JST['templates/comment']({
          comment: dataParse.comment,
          user_email: dataParse.user_email
        } ))
  })
