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
  if($(this).attr("data-status") == 'added'){
    $('.poll-option').empty();
    $(this).text('Добавить голосование').removeAttr('data-status');
  }
  else{
    $(this).after(
      `<ul class="poll-option">
        <li class="d-flex align-items-center">
          <span class="poll-option-title">Вариант </span>
          <input type="text" name="poll_option" required>
          <a class="poll-option-remove"><i class="fas fa-times-circle"></i></a>
        </li>
        <button class="btn btn-light btn-sm poll-option-btn-add">Добавить вариант</button>
      </ul>`).text('Удалить голосование');
      $(this).attr("data-status", "added");
  }
});

$(document).on('click', '.poll-option-btn-add', function(e){
  e.preventDefault();
  $(this).before(
    `<li class="d-flex align-items-center">
      <span class="poll-option-title">Вариант </span>
      <input type="text" name="poll_option" required>
      <a class="poll-option-remove"><i class="fas fa-times-circle"></i></a>
    </li>`);
});

$(document).on('click', '.poll-option-remove', function(e){
  e.preventDefault();

  $(this).parents('li').remove();
})

$('#btn-test').on('click', function(e){
  e.preventDefault();
  var items = {};
  var pollObject = $('.poll-option>li>input').map(function(index, element){
    return $(element).val();
  }).get();
  console.log('Результ', JSON.stringify(pollObject));
})