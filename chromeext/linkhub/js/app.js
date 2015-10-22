/**
 * Created by everettjf on 10/22/15.
 */

function serverUrl(partialUrl){
    return 'http://0.0.0.0:5000/' + partialUrl;
}

var linkhubApp = angular.module('linkhubApp',[]);
var linkhubScope = null;

linkhubApp.controller('linkhubCtrl',['$scope','$http',function($scope,$http){
    console.log('controller');
    linkhubScope = $scope;

    // Check login status
    $.ajax({
        type:'POST',
        url:serverUrl('api/get_current_user'),
        data:JSON.stringify({
            endpoint:'chrome'
        }),
        dataType:'json',
        contentType:'application/json; charset=utf-8'
    }).done(function(data){
        console.log('succeed=' + data.email);
    }).fail(function(){
        console.log('fail check login');
    });
}]);


function initPageInfo(){
    var queryInfo = {
        active:true,
        currentWindow:true
    };

    chrome.tabs.query(queryInfo, function(tabs){
        console.log('active tab got');
        var tab = tabs[0];

        // Update UI
        linkhubScope.linkTitle = tab.title;
        linkhubScope.linkUrl = tab.url;
        linkhubScope.linkFavicon = tab.favIconUrl;
        linkhubScope.$apply();



        // Check if added , otherwise try add it


    });
}

document.addEventListener('DOMContentLoaded', function() {
    console.log('dom loaded');

    initPageInfo();
});



