$(document).on('turbolinks:load', function(){
   $('.question').on('click', '.subscribe-question-link', function(e) {
       e.preventDefault();
       $(this).hide();
      //  $('form#edit-question-form').show();
   })
}); 
