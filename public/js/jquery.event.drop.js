(function(e){e.fn.drop=function(t,n,r){var i=typeof t=="string"?t:"",s=e.isFunction(t)?t:e.isFunction(n)?n:null;if(i.indexOf("drop")!==0)i="drop"+i;r=(t==s?n:r)||{};return s?this.bind(i,r,s):this.trigger(i)};e.drop=function(t){t=t||{};r.multi=t.multi===true?Infinity:t.multi===false?1:!isNaN(t.multi)?t.multi:r.multi;r.delay=t.delay||r.delay;r.tolerance=e.isFunction(t.tolerance)?t.tolerance:t.tolerance===null?null:r.tolerance;r.mode=t.mode||r.mode||"intersect"};var t=e.event,n=t.special,r=e.event.special.drop={multi:1,delay:20,mode:"overlap",targets:[],datakey:"dropdata",livekey:"livedrop",add:function(n){var i=e.data(this,r.datakey);i.related+=1;if(!i.live&&n.selector){i.live=true;t.add(this,"dropinit."+r.livekey,r.delegate)}},remove:function(){e.data(this,r.datakey).related-=1},setup:function(){if(e.data(this,r.datakey))return;var t={related:0,active:[],anyactive:0,winner:0,location:{}};e.data(this,r.datakey,t);r.targets.push(this)},teardown:function(){if(e.data(this,r.datakey).related)return;e.removeData(this,r.datakey);t.remove(this,"dropinit",r.delegate);var n=this;r.targets=e.grep(r.targets,function(e){return e!==n})},handler:function(i,s){var o,u;if(!s)return;switch(i.type){case"mousedown":u=e(r.targets);if(typeof s.drop=="string")u=u.filter(s.drop);u.each(function(){var t=e.data(this,r.datakey);t.active=[];t.anyactive=0;t.winner=0});s.droppable=u;r.delegates=[];n.drag.hijack(i,"dropinit",s);r.delegates=e.unique(n.drag.flatten(r.delegates));break;case"mousemove":r.event=i;if(!r.timer)r.tolerate(s);break;case"mouseup":r.timer=clearTimeout(r.timer);if(s.propagates){n.drag.hijack(i,"drop",s);n.drag.hijack(i,"dropend",s);e.each(r.delegates||[],function(){t.remove(this,"."+r.livekey)})}break}},delegate:function(n){var i=[],s,o=e.data(this,"events")||{};e.each(o.live||[],function(o,u){if(u.preType.indexOf("drop")!==0)return;s=e(n.currentTarget).find(u.selector);if(!s.length)return;s.each(function(){t.add(this,u.origType+"."+r.livekey,u.origHandler,u.data);if(e.inArray(this,i)<0)i.push(this)})});r.delegates.push(i);return i.length?e(i):false},locate:function(t,n){var i=e.data(t,r.datakey),s=e(t),o=s.offset()||{},u=s.outerHeight(),a=s.outerWidth(),f={elem:t,width:a,height:u,top:o.top,left:o.left,right:o.left+a,bottom:o.top+u};if(i){i.location=f;i.index=n;i.elem=t}return f},contains:function(e,t){return(t[0]||t.left)>=e.left&&(t[0]||t.right)<=e.right&&(t[1]||t.top)>=e.top&&(t[1]||t.bottom)<=e.bottom},modes:{intersect:function(e,t,n){return this.contains(n,[e.pageX,e.pageY])?1e9:this.modes.overlap.apply(this,arguments)},overlap:function(e,t,n){return Math.max(0,Math.min(n.bottom,t.bottom)-Math.max(n.top,t.top))*Math.max(0,Math.min(n.right,t.right)-Math.max(n.left,t.left))},fit:function(e,t,n){return this.contains(n,t)?1:0},middle:function(e,t,n){return this.contains(n,[t.left+t.width*.5,t.top+t.height*.5])?1:0}},sort:function(e,t){return t.winner-e.winner||e.index-t.index},tolerate:function(t){var i,s,o,u,a,f,l,c=0,h,p=t.interactions.length,d=[r.event.pageX,r.event.pageY],v=r.tolerance||r.modes[r.mode];do if(h=t.interactions[c]){if(!h)return;h.drop=[];a=[];f=h.droppable.length;if(v)o=r.locate(h.proxy);i=0;do if(l=h.droppable[i]){u=e.data(l,r.datakey);s=u.location;if(!s)continue;u.winner=v?v.call(r,r.event,o,s):r.contains(s,d)?1:0;a.push(u)}while(++i<f);a.sort(r.sort);i=0;do if(u=a[i]){if(u.winner&&h.drop.length<r.multi){if(!u.active[c]&&!u.anyactive){if(n.drag.hijack(r.event,"dropstart",t,c,u.elem)[0]!==false){u.active[c]=1;u.anyactive+=1}else u.winner=0}if(u.winner)h.drop.push(u.elem)}else if(u.active[c]&&u.anyactive==1){n.drag.hijack(r.event,"dropend",t,c,u.elem);u.active[c]=0;u.anyactive-=1}}while(++i<f)}while(++c<p);if(r.last&&d[0]==r.last.pageX&&d[1]==r.last.pageY)delete r.timer;else r.timer=setTimeout(function(){r.tolerate(t)},r.delay);r.last=r.event}};n.dropinit=n.dropstart=n.dropend=r})(jQuery)