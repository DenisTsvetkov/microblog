$.getScript('js/ajax.js', function(){
    $('#subscribe-btn, .subscribe-btn').on('click', function(e){
    e.preventDefault();

    let btnSubscribe = $(this);

    let data = {
        'action':$(this).data('action')
    };
    if(window.location.pathname == "/people" || window.location.pathname == "/subscriptions" || window.location.pathname == "/subscribers"){
        data.user_subscribe = $(this).parents('li').data('id')
    }
    else{
        data.user_subscribe = $('.dashboard>.profile-card').data('id');
    }
    AJAX('/subscribe', 'POST', data, function(res){
            if(window.location.pathname == "/subscriptions"){
                if(res.unsubscribe){
                    btnSubscribe.parents('li').hide(300, function(){
                        btnSubscribe.parents('li').remove();
                        $('#subscriptions > span').text(parseInt(($('#subscriptions > span').text()))-1);
                    })
                }
            }
            else if(window.location.pathname == "/subscribers"){
                if(res.unsubscribe){
                    btnSubscribe.removeClass('btn-secondary').addClass('btn-primary').data('action', 'subscribe').text('Подписаться в ответ');
                    $('#subscriptions > span').text(parseInt(($('#subscriptions > span').text()))-1);
                }
                if(res.subscribe){
                    btnSubscribe.removeClass('btn-primary').addClass('btn-secondary').data('action', 'unsubscribe').text('Отписаться');
                    $('#subscriptions > span').text(parseInt(($('#subscriptions > span').text()))+1);
                }
            }
            else if(window.location.pathname == "/people"){
                if(res.unsubscribe){
                    btnSubscribe.removeClass('btn-secondary').addClass('btn-primary').data('action', 'subscribe').text('Подписаться');
                    $('#subscriptions > span').text(parseInt(($('#subscriptions > span').text()))-1);
                }
                if(res.subscribe){
                    btnSubscribe.removeClass('btn-primary').addClass('btn-secondary').data('action', 'unsubscribe').text('Отписаться');
                    $('#subscriptions > span').text(parseInt(($('#subscriptions > span').text()))+1);
                }
            }
            else{
                if(res.unsubscribe){
                    btnSubscribe.removeClass('btn-secondary').addClass('btn-primary').data('action', 'subscribe').text('Подписаться');
                    $('#subscribers > span').text(parseInt(($('#subscribers > span').text()))-1);
                }
                if(res.subscribe){
                    btnSubscribe.removeClass('btn-primary').addClass('btn-secondary').data('action', 'unsubscribe').text('Отписаться');
                    $('#subscribers > span').text(parseInt(($('#subscribers > span').text()))+1);
                }
            }
            
            
        })
    })
});