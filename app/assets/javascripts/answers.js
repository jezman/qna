$(document).on('turbolinks:load', function(){
   $('.answers').on('click', '.edit-answer-link', function(e) {
       e.preventDefault();
       $(this).hide();
       var answerId = $(this).data('answerId');
       console.log(answerId);
       $('form#edit-answer-' + answerId).removeClass('hidden');
   })

   $('.answers').on('click', '.delete-answer-link', function(e) {
       e.preventDefault();
       var answerId = $(this).data('answerId');
       console.log(answerId);
       $('.answer-' + answerId).remove();
   })
}); 
