;(function(){
	//自定义log组件，用于客户端调试

	var elLog;
	var inited = false;
	var cache = [];

	window.log = function(){
		var info = Array.prototype.slice.call(arguments).join(' ');
		var p;
		if(inited){
			p = document.createElement('p');
			p.innerHTML = info;
			elLog.appendChild(p);
			elLog.style.display = '';
		}else{
			cache.push(info);
		}
	};

	setTimeout(function(){
		var cacheInfos = cache.map(function(str){
			return '<p>' + str + '</p>';
		}).join('');
		if(!elLog){
			elLog = document.createElement('div');
			elLog.style.cssText = [
				'display:none;',
				'position:fixed;',
				'bottom:60px;',
				'width:100%;',
				'max-height:200px;',
				'overflow:auto;',
				'-webkit-overflow-scrolling:touch;',
				'background:rgba(0,0,0,0.5);',
				'color:#fff;',
				'font-size:9px;',
				'word-wrap: break-word;',
				'word-break: break-all;',
				'z-index: 9999;'
			].join('');
			document.body.appendChild(elLog);
		}
		if(cacheInfos){
			elLog.innerHTML = cacheInfos;
			elLog.style.display = '';
		}

		inited = true;
	}, 500);

})();


