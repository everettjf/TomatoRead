/**
 * Created by everettjf on 16/1/24.
 */
function logInfo(prefix,content){
    console.log(prefix + '|' + content);
}

var clog=function(content){
    logInfo('common',content);
};

function jsonPost(relativeUrl,parameter,done,fail){
    $.ajax({
        type:'POST',
        url:relativeUrl,
        data:JSON.stringify(parameter),
        dataType:'json',
        contentType:'application/json; charset=utf-8'
    }).done(function(data){
        clog('succeed:' + relativeUrl);
        done(data);
    }).fail(function(resp){
        clog('fail('+ resp.status + '):' + relativeUrl);
        fail();
    });
}
function jsonGet(relativeUrl,parameter,done,fail){
    $.ajax({
        type:'GET',
        url:relativeUrl,
        data:parameter,
        dataType:'json',
        contentType:'application/json; charset=utf-8'
    }).done(function(data){
        clog('succeed:' + relativeUrl);
        done(data);
    }).fail(function(resp){
        clog('fail('+ resp.status + '):' + relativeUrl);
        fail();
    });
}

$(document).ready(function(){
  $("#bookmark_link").click(function(){
      bid = $(this).attr('bookmark_id');
      jsonPost('/api/bookmark_click/',{
          id:bid
      },function(data){

      }, function () {
      });
  });
});
