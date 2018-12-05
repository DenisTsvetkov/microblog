function showClassStars(stars, element){
    element.children($('.fa-star')).remove();
    for(var i=1; i<=5; i++){
        if(i<=stars){
            element.append('<i class="fas fa-star active"></i>');
        }
        else{
            element.append('<i class="fas fa-star"></i>');
        }
    }
}

function setClassHotel(element){
    // element.on('mouseover', 'i', function() {
    //     element.children('i:nth-child(-n+'+($(this).index()+1)+')').addClass('active');
    // })
    // element.on('mouseout', 'i', function() {
    //     element.children('i:nth-child(-n+'+($(this).index()+1)+')').removeClass('active');
    // })
    element.on('click', 'i', function() {
        element.children(element>'i').removeClass('active');
        element.children('i:nth-child(-n+'+($(this).index()+1)+')').addClass('active');
        var countActiveStars = element.children(".active").length;
        //alert(countActiveStars);
        $('.popup form > input[type="hidden"]').val(countActiveStars);
    })
    
    // $('.popup form > input[type="hidden"]').on('change', ()=>{
    //     var d = $('.popup form > input[type="hidden"]').val();
    //     element.children('i:nth-child(-n+'+d+')').removeClass('active');
    // })
    
}