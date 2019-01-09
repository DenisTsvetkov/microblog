$.getScript('js/ajax.js', function(){
    $('.post-comments').on('click', function(e){
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
            console.log(thisPost);
            console.log($.trim(thisPostContent));
            console.log('Аватар', thisPostAuthorAvatar)
            $('#gridSystemModal').find('.post-content').text($.trim(thisPostContent));
            $('#gridSystemModal').find('.post-name').text($.trim(thisPostAuthorName));
            $('#gridSystemModal').find('.post-username').text($.trim(thisPostAuthorUsername));
            $('#gridSystemModal').find('.post-created-date').text($.trim(thisPostCreatedDate));

            $('#gridSystemModal').find('.post-avatar > img').attr('src', thisPostAuthorAvatar).attr('alt', thisPostAuthorName);

            console.log(res.postComments);
            $('#gridSystemModal .post-comments').children('.comment').empty();
            
            if(res.postComments.length != 0){
                $.each(res.postComments, function( index, value ) {
                    $('.poll .poll-option').append(
                        `<div class='comment'>
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