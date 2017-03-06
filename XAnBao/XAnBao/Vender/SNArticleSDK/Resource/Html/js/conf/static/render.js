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
				'position:absolute;',
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

;(function(){
	//页面内容渲染

	if(!window.mustache){return;}

	var AP = Array.prototype;
	var OP = Object.prototype;

	var typeOf = function(obj){
		return OP.toString.call(obj).toLowerCase().replace(/(\[object\s|\])/g, '');
	};

	var getUniqueKey = (function(){
		var time = + new Date(), index = 1;
		return function(){
			return ( time + (index++) ).toString(16);
		};
	})();

	var simpleJsBridge = (function(){
		var iframe;
		var request = function(method){
			var name = 'jsbridge' + getUniqueKey();
			var src = 'jsbridge://' + name;
			var message = JSON.stringify({
				method : method
			});

			if(window.jsBridge && window.jsBridge.process){
				window.jsBridge.process(message);
			}else{
				window[name] = message;

				if(!iframe){
					iframe = document.createElement('iframe');
					iframe.style.display = 'none';
					iframe.src = src;
					document.body.appendChild(iframe);
				}else{
					setTimeout(function(){
						iframe.src = src;
					});
				}

				setTimeout(function(){
					delete window[name];
					document.body.removeChild(iframe);
				}, 3000);
			}
		};

		return {
			request : request
		};
	})();

	//各个组件隶属的类型名称存入一个数组	
	var BELONG_TYPES = [];

	//构造一个TPL对象，存储模板数据
	var TPL = (function(){
		var templates = {};
		var tplNodes = document.querySelectorAll('script[type="x-tmpl"]');
		var belongTypes = {};
		tplNodes = AP.slice.call(tplNodes);
		tplNodes.forEach(function(el){
			var name = el.getAttribute('name');
			var belong = el.getAttribute('belong') || 'box_content';
			belongTypes[belong] = true;
			templates[name] = {
				html : el.innerHTML,
				belong : belong
			};
		});
		BELONG_TYPES = Object.keys(belongTypes);
		return templates;
	})();

	//对数据做默认的格式化
	//为数据添加platform属性，以便于模板区分平台进行渲染
	//对数组数据，为每一项添加index属性
	var autoFormat = (function(){
		var platform = $CONFIG.platform;
		if(!platform || typeOf(platform) !== 'string'){
			platform = 'android';
		}
		return function(rs){
			if(!rs){return {};}
			rs.platform = rs.platform || platform;
			if(typeOf(rs.data) === 'array'){
				rs.data.forEach(function(item, index){
					item.index = item.index || index;
				});
			}
			return rs;
		};
	})();

	//数据格式化处理器
	//如果有特殊类型的数据需要对数据进行特殊的格式化，在页面添加对应名称的数据过滤器
	var filter = (function(){
		var filterObj = {};
		var filterNodes = document.querySelectorAll('script[type="x-filter"]');
		filterNodes = AP.slice.call(filterNodes);
		filterNodes.forEach(function(el){
			var fn = eval(el.innerHTML);
			var forList = el.getAttribute('for') || '';
			forList = forList.split(',');
			if(typeOf(fn) === 'function'){
				forList.forEach(function(name){
					filterObj[name] = fn;
				});
			}
		});
		return filterObj;
	})();

	//渲染单个模块
	var renderItem = function(item){
		var name = item.type;
		var tpl;
		var html = '';
		var format = filter[name];

		try{
			item = autoFormat(item);
		}catch(e){
			if(console.error){
				console.error(name, 'autoFormat error', e);
			}
		}

		try{
			if(format){
				item = format(item);
			}
		}catch(e){
			if(console.error){
				console.error(name, 'filter error', e);
			}
		}

		try{
			tpl = TPL[name];
			if(tpl && tpl.html){
				html = mustache.render(tpl.html, item);
			}
		}catch(e){
			if(console.error){
				console.error(name, 'render error', e);
			}
		}

		return html;
	};

	//通过html获取dom元素
	var getNode = (function(){
		var tempNodeBox = document.createElement('div');
		return function(html){
			var node;
			tempNodeBox.innerHTML = html;
			node = tempNodeBox.children.item(0);
			if(node){
				tempNodeBox.removeChild(node);
			}
			return node;
		};
	})();

	var readyCache = [];
	var renderComplete = false;
	//绑定htmlReady事件
	var bindHtmlReady = function(fn){
		if(typeOf(fn) === 'function'){
			if(renderComplete){
				fn();
			}else{
				readyCache.push(fn);
			}
		}
	};
	//在htmlReady时触发
	var onHtmlReady = function(){
		renderComplete = true;
		var fn;
		while(readyCache.length){
			fn = readyCache.shift();
			if(typeOf(fn) === 'function'){
				fn();
			}
		}
	};

	//执行渲染
	var render = function(rs){
		if(typeOf(rs) !== 'array'){return;}
		var boxNodes = {};

		var firstInsert = function(){
			var cache = [];
			var index;
			var item;
			for(index = 5; index > 0; index --){
				item = rs.shift();
				if(item){
					cache.push(item);
				}
			}
			batchRender(cache);
			simpleJsBridge.request('firstInsert');
		};

		//获取元素隶属的容器
		var getBelongBox = function(belong){
			belong = belong || '';
			if(!boxNodes[belong]){
				boxNodes[belong] = document.getElementById(belong);
			}
			return boxNodes[belong];
		};

		//根据组件类型名称获取隶属容器的id
		var getBelong = function(name){
			var tpl = TPL[name];
			if(!tpl){return;}
			return tpl.belong;
		};

		var doInsert = function(){
			var item = rs.shift();
			var name = item.type;
			var html = renderItem(item);
			var box = getBelongBox(getBelong(name));

			if(!html){return;}
			var node = getNode(html);
			if(node && box){
				box.appendChild(node);
			}
		};

		var batchRender = function(items){
			var frags = {};

			items.forEach(function(item){
				var name = item.type;
				var html = renderItem(item);

				if(!html){return;}

				var belong = getBelong(name);
				if(!frags[belong]){
					frags[belong] = document.createDocumentFragment();
				}

				var node = getNode(html);
				var frag = frags[belong];
				if(node && frag){
					frag.appendChild(node);
				}
			});

			BELONG_TYPES.forEach(function(belong){
				var box = getBelongBox(belong);
				if(box && frags[belong]){
					box.appendChild(frags[belong]);
				}
			});
		};

		var timer;
		var loop = window.requestAnimationFrame || window.webkitRequestAnimationFrame || window.setTimeout;
		var insertItem = function(){
			if(document.body.scrollHeight > screen.height){
				batchRender(rs);
				rs.length = 0;
			}else if(rs.length){
				doInsert();
				timer = loop(insertItem);
			}
			if(!rs.length){
				onHtmlReady();
			}
		};

		firstInsert();
		insertItem();

	};

	var startRender = function(rs){
		if(rs && rs.data && rs.data.slice){
			render(rs.data.slice(0));
		}
	};

	startRender($CONFIG.pageData);

	var htmlRender = {};
	htmlRender.renderItem = renderItem;
	htmlRender.ready = bindHtmlReady;

	window.htmlRender = htmlRender;

})();



