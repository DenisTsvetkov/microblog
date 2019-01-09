$('#exampleModal').on('show.bs.modal', function (event) {
    var modal = $(this)
    // modal.on('submit', function(event){
    //     event.preventDefault();
    //     console.log('Сработал submit')
    //     console.log(event);
    // })
  })

$('.poll-btn-add').on('click', function(e){
  e.preventDefault();
  $(this).before(
    `<li class="d-flex align-items-center">
      <span class="poll-option-title">Вариант </span>
      <input type="text">
      <a class="poll-option-remove"><i class="fas fa-times-circle"></i></a>
    </li>`);
})

$(document).on('click', '.poll-option-remove', function(e){
  e.preventDefault();

  $(this).parents('li').remove();
})