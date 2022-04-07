$(document).on('turbolinks:load', function() {
  $('.answers').on('click', '.edit-answer-link', function(e) {
    e.preventDefault();
    const answerId = $(this).data('answerId')
    $('form#edit-answer-' + answerId).removeClass('d-none')
  })
});
