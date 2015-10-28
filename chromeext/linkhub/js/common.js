/**
 * Created by everettjf on 10/22/15.
 */

function serverUrl(partialUrl){
    return 'http://0.0.0.0:5000/' + partialUrl;
}

function logInfo(prefix,content){
    console.log(prefix + '|' + content);
}

var clog=function(content){
    logInfo('common',content);
};

function jsonPost(relativeUrl,parameter,done,fail){
    $.ajax({
        type:'POST',
        url:serverUrl(relativeUrl),
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

// Helper
function apiCurrentUser(done,fail){
    jsonPost('api/user/current_user',{
        endpoint:'chrome'
    },
        done,
        fail
    );
}

function apiAddLink(req,done,fail){
    jsonPost('api/link/add',
        req,
        done,
        fail
    );
}

function apiRemoveLink(req,done,fail){
    jsonPost('api/link/remove',
        req,
        done,
        fail
    );
}

function apiUpdateLink(req,done,fail){
    jsonPost('api/link/update',
    req,done,fail);
}

function apiLinkInfo(req,done,fail){
    jsonPost('api/link/info',
    req,done,fail);
}
