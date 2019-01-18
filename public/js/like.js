$.getScript('js/ajax.js', function(){
    $('.post-likes').on('click', function(e){
        e.preventDefault();
        var countLikes = parseInt($(this).children('.post-action-list-value').text());
        let thisPost = $(this);
        let heartIcon = thisPost.children('i.fa-heart');

        let dashboardCountLikes = parseInt($('#count-liked-posts').children('span').text());

        if(!heartIcon.hasClass('liked')){
            AJAX('/like', 'POST', {
                'action':'like', 
                'post_id':thisPost.parents('.post').data('id')
            }, function(res){
                if(res.like){
                    thisPost.children('i.fa-heart').addClass('liked');
                    thisPost.children('.post-action-list-value').text(countLikes+1);
                    if($('.dashboard').children('button.btn').text() == "Изменить профиль"){
                        $('#count-liked-posts').children('span').text(dashboardCountLikes+1)
                    }
                }
            })
        }
        else{
            AJAX('/like', 'POST', {
                'action':'unlike', 
                'post_id':$(this).parents('.post').data('id')
            }, function(res){
                if(res.unlike){
                    thisPost.children('i.fa-heart').removeClass('liked');
                    thisPost.children('.post-action-list-value').text(countLikes-1);
                    if($('.dashboard').children('button.btn').text() == "Изменить профиль"){
                        $('#count-liked-posts').children('span').text(dashboardCountLikes-1)
                    }
                }
            })
        }
  })
});