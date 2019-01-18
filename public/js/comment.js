$.getScript('js/ajax.js', function(){
    $('#new-comment').submit(function(e){
        e.preventDefault();
        var newComment = {};
        $.each($(this).serializeArray(), function(i, field) {
            newComment[field.name] = field.value;
        });

        AJAX('/comment', 'POST', newComment, function(res){
                $(
                    `<div class='comment' data-id='${res.comment.id}' style='display: none;'>
                        <span class="comment-delete"><i class="fas fa-times"></i></span>
                        <div class='comment-avatar'>
                            <img src='${res.user.avatar_src}' alt='${res.user.name} ${res.user.surname}' class='align-bottom'>
                        </div>
                        <span class='comment-name'>${res.user.firstname} ${res.user.surname}</span>
                        <span class='comment-username'> @${res.user.username}</span>
                        <span class='comment-created-date'>${res.comment.date}</span>
                        <p class='comment-content'>
                            ${res.comment.content}
                        </p>
                    </div>`
                ).prependTo('#gridSystemModal .post-comments .list-comments').fadeIn(1000);


                $('#comment_text').val("");
                $('.comments-not-found').remove();
        })
       
  });

  $(document).on('click', '.comment-delete', function(e){
      e.preventDefault();
      let thisComment = $(this).parents('.comment')
      
      AJAX('/delete_comment', 'POST', {'id_comment': thisComment.data('id')}, function(res){
        if(res.uncomment == true){
            thisComment.fadeOut(300, function(){
                thisComment.remove();
            });
        }
      })
  });
});