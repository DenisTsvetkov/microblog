$.getScript('js/ajax.js', function(){
    $('.poll-option-answer').on('click', function(e){
        let thisPoll = $(this).parents('.post-poll').data('poll-id');
        let thisAnswer = $(this).data('answer');
        AJAX('/vote', 'POST', {
            'action':'vote', 
             'id_poll': thisPoll,
             'answer': thisAnswer
        }, function(res){
            location.reload();
        })
    })
});