/**
 * Created by everettjf on 10/22/15.
 */

//var baseURL = 'http://0.0.0.0:8888/';
var baseURL = 'http://iosblog.cc/';

function serverUrl(partialUrl){
    return baseURL + partialUrl;
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
function jsonPut(relativeUrl,parameter,done,fail){
    $.ajax({
        type:'PUT',
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
function jsonDelete(relativeUrl,parameter,done,fail){
    $.ajax({
        type:'DELETE',
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
function jsonGet(relativeUrl,parameter,done,fail){
    $.ajax({
        type:'GET',
        url:serverUrl(relativeUrl),
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

// Helper
function apiCurrentUser(done,fail){
    jsonGet('api/auth_info/',{
        endpoint:'chrome'
    },
        done,
        fail
    );
}

function apiSaveLink(req,done,fail){
    jsonPost('api/bookmark_save/',
    req,done,fail);
}

function apiLinkInfo(req,done,fail){
    jsonPost('api/bookmark_existed/',
    req,done,fail);
}

function chromeIconOn(){
    chrome.pageAction.setIcon({
        tabId:currentTabID,
        path:'image/on.png',
    },function(){
    });
}
function chromeIconOff(){
    chrome.pageAction.setIcon({
        tabId:currentTabID,
        path:'image/off.png',
    },function(){
    });
}

