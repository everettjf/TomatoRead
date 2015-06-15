'use strict';

var extensionApp = angular.module('extensionApp',[]);

var logError = function(data,status){
    console.log('code' + status + ':' + data);
};

var serverURL = function(partialURL){
    return 'http://127.0.0.1:8086' + partialURL;
}
extensionApp.controller('ExtensionCtrl',['$scope','$http',function($scope,$http){
    console.log('angular extension');
    $scope.addResult = "Click to add this link.";

    $scope.addLink = function(){
        console.log('new link');

        var title = $scope.linkTitle;
        var url = $scope.linkURL;
        var tagString = $scope.linkTagString;

        if(title == "" || url == ""){
            $scope.addResult = "Failed : Title and url cannot be empty.";
            return;
        } 

        if(tagString == ""){
            $scope.addResult = "Failed : Tag cannot be empty.";
            return;
        }

        $http.post(serverURL('/link/new/'),{
            Title:title,
            URL:url,
            TagString:tagString
        }).success(function(){
            $scope.addResult = "Succeed add this link.";
        }).error(function(data,status){
            $scope.addResult = "Failed : " + data;
            logError(data,status);
        });
    };

    $scope.allTabLinks = [];
    $scope.batchAddResult = '';
    $scope.batchAddLink = function(){
        $http.post(serverURL('/link/batchnew/'),{
            Count:$scope.allTabLinks.length,
            Links:$scope.allTabLinks
        }).success(function(){
            $scope.batchAddResult = 'Succeed';
        }).error(function(data,status){
            $scope.batchAddResult = 'Error:' + data;
        });
    };

    $scope.inputEmail="everettjf@qq.com";
    $scope.inputPassword="hellohello";
    $scope.signMessage="waiting...";

    $scope.signIn = function(){
        $http.post(serverURL('/user/signin'),{
            Email:$scope.inputEmail,
            Password:$scope.inputPassword
        }).success(function(data){
            $scope.signMessage = "Success";
        }).error(function(data,status){
            $scope.signMessage="Error:" + data;
        });
    };
    $scope.signOut = function(){
        $http.post(serverURL('/user/signout'),{
        }).success(function(data){
            $scope.signMessage = "Success";
        }).error(function(data,status){
            $scope.signMessage="Error:" + data;
        });
    };

    $scope.importMessage = "";
    $scope.importAllBookmarks = function(){
        chrome.bookmarks.getTree(function(treeNodeArray){
            beginSendAllBookmarks();
            sendAllBookmarks(treeNodeArray);
            endSendAllBookmarks();
        });
    };

    $scope.appendTag = function(tagName) {
        $scope.linkTagString = tagName + " " + $scope.linkTagString;
    };
}]);

var gImportedBookmarksCount = 0;
function beginSendAllBookmarks(){
    gImportedBookmarksCount = 0;
    var $scope = extensionCtrlScope();
    $scope.importMessage = 'Importing...';
    $scope.$apply();
}

function endSendAllBookmarks(){
    var $scope = extensionCtrlScope();
    $scope.importMessage = 'Import Completed: ' + gImportedBookmarksCount + ' Bookmarks Imported.';
    $scope.$apply();
}
function countBookmarks(count){
    gImportedBookmarksCount += count;
    var $scope = extensionCtrlScope();
    $scope.importMessage = ' ' + gImportedBookmarksCount + ' Bookmarks Imported.';
    $scope.$apply();
}
function sendAllBookmarks(treeNodeArray){
    var nodeLinks = [];
    for(var index in treeNodeArray){
        var node = treeNodeArray[index];
        if(node.children != undefined){
            sendAllBookmarks(node.children);
        }else{
            var title = node.title;
            var url = node.url;

            nodeLinks.push({
                Title:title,
                URL:url
            });
        } 
    }

    $.ajax({
      type: 'POST',
      url: serverURL('/link/batchnew/'),
      processData:false,
      data: JSON.stringify({
        Count:nodeLinks.length,
        Links:nodeLinks
      }),
      success: function(data,status){
        countBookmarks(nodeLinks.length);
    }});
}

function getCurrentTabUrl(callback) {
    var queryInfo = {
        active: true,
        currentWindow: true
    };

    chrome.tabs.query(queryInfo, function(tabs) {
        var tab = tabs[0];

        var url = tab.url;
        var title = tab.title;

        console.assert(typeof url == 'string', 'tab.url should be a string');
        console.assert(typeof title == 'string', 'tab.title should be a string');

        callback(title,url);
    });
}

function getAllTabUrl(callback){
    var queryInfo = {
        currentWindow: true
    };

    chrome.tabs.query(queryInfo, function(tabs) {
        var allTabLinks = [];
        for(var index in tabs){
            var tab = tabs[index];
            var url = tab.url;
            var title = tab.title;
            allTabLinks.push({
                Title:title,
                URL:url
            });
        }
        console.log(allTabLinks);
        callback(allTabLinks);
    });
}

function extensionCtrlScope(){
    return angular.element(document.getElementById('extensionCtrl')).scope();
}

angular.element(document).ready(function() {
    console.log('dom content loaded');
    var $scope = extensionCtrlScope();
    $scope.linkStatus = 'waiting...';

    getCurrentTabUrl(function(title,url) {
        var $scope = extensionCtrlScope();
        $scope.linkStatus = '';

        $scope.linkTitle = title;
        $scope.linkURL = url;
        $scope.linkTagString = '';
        $scope.$apply();

        $.ajax({
          type: 'POST',
          url: serverURL('/util/extracttags/'),
          processData:false,
          data: JSON.stringify({
            Title:$scope.linkTitle,
            URL:$scope.linkURL
          }),
          success: function(data,status){
            console.log(data);
            var $scope = extensionCtrlScope();

            var tagString = "";
            for(var key in data){
                tagString += data[key];
                tagString += " ";
            }
            $scope.linkTagString = tagString;
            $scope.$apply();
        }});
    });

    getAllTabUrl(function(allTabLinks){
        var $scope = extensionCtrlScope();
        $scope.allTabLinks = allTabLinks;
        $scope.$apply();
    });
});

$('#topTab a').click(function (e) {
    e.preventDefault()
    $(this).tab('show')
});