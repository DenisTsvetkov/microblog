$.getScript('js/ajax.js', function(){
    $('#subscribe-btn').on('click', function(e){
    e.preventDefault();
    AJAX('/subscribe', 'POST', {
        'action':$(this).data('action'), 
        'user_subscribe': $('.dashboard>.profile-card').data('id')
    }, function(res){
            if(res.unsubscribe){
                $('#subscribe-btn').removeClass('btn-secondary').addClass('btn-primary').data('action', 'subscribe').text('Подписаться');
                $('#subscribers > span').text(parseInt(($('#subscribers > span').text()))-1);
            }
            if(res.subscribe){
                $('#subscribe-btn').removeClass('btn-primary').addClass('btn-secondary').data('action', 'unsubscribe').text('Отписаться');
                $('#subscribers > span').text(parseInt(($('#subscribers > span').text()))+1);
            }
        })
    })
});