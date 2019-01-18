$.getScript('js/ajax.js', function(){
    $('.post-action-list > .post-comments').on('click', function(e){
        e.preventDefault();
        
        let thisPost = $(this).parents('.post');
        let thisPostContent = thisPost.children('.post-content').text();
        let thisPostAuthorName = thisPost.children('.post-name').text();
        let thisPostAuthorUsername = thisPost.children('.post-username').text();
        let thisPostAuthorAvatar = thisPost.children('.post-avatar').children('img').attr('src');
        let thisPostCreatedDate = thisPost.children('.post-created-date').text();
        
        AJAX('/post-info', 'POST', {
            'post_id':thisPost.data('id')
        }, function(res){
            $('#gridSystemModal').find('.post-content').text($.trim(thisPostContent));
            $('#gridSystemModal').find('.post-name').text($.trim(thisPostAuthorName));
            $('#gridSystemModal').find('.post-username').text($.trim(thisPostAuthorUsername));
            $('#gridSystemModal').find('.post-created-date').text($.trim(thisPostCreatedDate));

            $('#gridSystemModal').find('.post-avatar > img').attr('src', thisPostAuthorAvatar).attr('alt', thisPostAuthorName);


            $('#gridSystemModal #new-comment #id_post').val(thisPost.data('id'));
            $('#gridSystemModal .post-comments .list-comments').children('.comment').empty();
            
            if(res.postComments.length != 0){
                $.each(res.postComments, function( index, value ) {
                    $('#gridSystemModal .post-comments .list-comments').append(
                        `<div class='comment' data-id='${value.id_comment}'>
                            <div class='comment-avatar'>
                                <img src='${value.avatar_src}' alt='${value.firstname} ${value.surname}' class='align-bottom'>
                            </div>
                            <span class='comment-name'>${value.firstname} ${value.surname}</span>
                            <span class='comment-username'> @${value.username}</span>
                            <span class='comment-created-date'>${value.date}</span>
                            <p class='comment-content'>
                                ${value.content}
                            </p>
                        </div>`
                    );
                    if(value.id_user == res.loginedUser){
                        $('#gridSystemModal .post-comments .list-comments .comment').last().prepend(
                            `<span class="comment-delete"><i class="fas fa-times"></i></span>`
                        );
                    }
                });
            }
            else{
                $('#gridSystemModal .post-comments').children('.comments-not-found').empty();
                $('#gridSystemModal .post-comments').append(
                    `<div class="comments-not-found">
                        <p>Эту запись ещё никто не комментировал</p>
                    </div>`
                )
            }
            $('#gridSystemModal').modal('show');
        })
    })
});