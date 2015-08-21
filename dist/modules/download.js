"use strict";var Download,ProgressBar,_,async,chalk,fs,mixin,request;_=require("lodash"),async=require("async"),request=require("superagent"),ProgressBar=require("progress"),chalk=require("chalk"),fs=require("fs"),mixin=require("./mixin"),Download=function(){function e(){}return e.prototype.run=function(e){return function(n){return function(r){return async.waterfall([n._getId(e),n._getVimeoPage(),n._getRequestFiles(),n._downloadVideo(e)],function(e,n){return r(e,n)})}}(this)},e.prototype._getId=function(e){return function(n){var r,t,o;return t=process.cwd()+"/"+e+"/manifest.json",o=require(t),r=_.find(o,{status:"created"}),mixin.write("cyan","\n------------------"),mixin.write("cyan","\nId 		: "+r.id),mixin.write("cyan","\nName 		: "+r.name),n(null,null!=r?r.id:void 0)}},e.prototype._getVimeoPage=function(){return function(e,n){var r;return r=e,request.get("https://player.vimeo.com/video/"+r).end(function(e,r){return n(null,r.text)})}},e.prototype._getRequestFiles=function(){return function(e,n){var r,t,o,u,i,l,s;return r=e,i=/t={(.*)};if/,l=/{(.*)}/,s=null!=r?r.match(i):void 0,s=null!=(o=s[0])?o.match(l):void 0,t=JSON.parse(s[0]),n(null,null!=t&&null!=(u=t.request)?u.files:void 0)}},e.prototype._downloadVideo=function(e){return function(n,r){var t,o,u,i;return t=n,i=null!=t&&null!=(o=t.h264)&&null!=(u=o.hd)?u.url:void 0,mixin.write("cyan","\nUrl 		: "+i),request.get(i).parse(function(n,r){var t,o,u;return u={complete:"=",incomplete:" ",width:20,total:parseInt(n.headers["content-length"],10)},t=new ProgressBar("Downloading 	: [:bar] :percent :etas",u),o=[],n.on("data",function(e){return t.tick(e.length),o.push(e)}),n.on("end",function(){return console.log("end"),fs.writeFile(process.cwd()+"/"+e+"/__ralph.mp4",new Buffer(o),function(e){return console.log("err")})})}).end(function(e,n){return console.log("result?.body",null!=n?n.body:void 0),r(e,n)})}},e}(),module.exports=Download;