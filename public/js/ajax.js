function AJAX(url, method, data, callback){
    $.ajax({
        type: method,
        url: url,
        data: data,
        success: function(msg){
          callback(msg);
        }
      });
}