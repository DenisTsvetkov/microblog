$('.poll-btn-add').on('click', function(e){
  e.preventDefault();
  if($(this).attr("data-status") == 'added'){
    $('.poll-option').empty();
    $('#poll-title').remove();
    $(this).text('Добавить голосование').removeAttr('data-status');
  }
  else{
    $(this).after(
      `<div class="input-group mb-3" id="poll-title">
        <input type="text" class="form-control" name="poll_title" placeholder="Заголовок голосования">
      </div>`).text('Удалить голосование');
    $('#poll-title').after(
      `<ul class="poll-option">
        <li class="d-flex align-items-center">
          <span class="poll-option-title">Вариант </span>
          <input type="text" name="poll_option" required>
          <a class="poll-option-remove"><i class="fas fa-times-circle"></i></a>
        </li>
        <button class="btn btn-light btn-sm poll-option-btn-add">Добавить вариант</button>
      </ul>`);
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
})