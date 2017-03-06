;(function(){
	//客户端需求图片要尽早加载，所以这里提前初始化一个listener专门负责处理图片的下载

	var AP = Array.prototype;
	var UI_NAME = 'ui-imgbox';

	var uiconf = {
		styleError : 'error',
		styleErrorSmall : 'C_downloadsmall',
		styleLoading : 'loading'
	};

	//依据图片元素查找对应图片盒子元素
	var findImgBox = function(imgNode){
		var imgBox;
		if(imgNode.hasAttribute(UI_NAME)){
			imgBox = imgNode;
		}else{
			var el = imgNode;
			//ios的webview中，元素的parentNode属性有可能会指向到自己
			//因此这里不使用while(el.parentNode)的方式循环，并添加循环次数限制
			for(var index = 0; index < 10; index++){
				if(el.hasAttribute(UI_NAME)){
					imgBox = el;
					break;
				}
				if(!el || el === el.parentNode){
					break;
				}
				el = imgNode.parentNode;
			}
		}
		return imgBox;
	};

	//依据属性条件寻找最近的父亲节点 param参数必须是节点的属性值
	var closestWrap = function(imgNode, param){
		var wrapper;
		if(imgNode.hasAttribute(param)){
			wrapper = imgNode;
		}else{
			var el = imgNode;
			//此处循环条件次数限制同上
			for(var index = 0; index < 10; index++){
				if(el.hasAttribute(param)){
					wrapper = el;
					break;
				}
				el = el.parentNode;
			}
		}
		return wrapper;
	}

	var loadImg = function(rs){
		if(!rs || !rs.target){return;}

		//客户端发送的JSON数据需要有2个属性：target, url
		//target为图片的ID或者原始地址
		//url为图片的本地地址
		var target = rs.target || '';
		var url = rs.url || '';
		target = target.trim();
		url = url.trim();

		var nodes = AP.slice.call(document.querySelectorAll('[data-src="' + target + '"]'));
		nodes = nodes.concat(AP.slice.call(document.querySelectorAll('[data-bg="' + target + '"]')));

		nodes.forEach(function(imgNode){
			var imgBox = findImgBox(imgNode);
			if((/\.gif$/).test(url)){
				imgNode.style.height = '';
			}
			if(url){
				if(imgNode.hasAttribute('data-src')){
					imgNode.src = url;
				}else{
					imgNode.style.backgroundImage = 'url(' + url + ')';
				}
			}else{
				// 清空src，添加加载失败样式
				imgNode.src = '';
				//此处对大图默认图进行优化
				var smallPicWrapper = closestWrap(imgNode, 'data-pl');
				if(smallPicWrapper &&
					smallPicWrapper.getAttribute('data-pl') === 'pic' &&
					smallPicWrapper.classList &&
					!smallPicWrapper.classList.contains('M_picsmall')){
					//大图 不同高度默认图不一样
					if(imgBox.offsetHeight > 90){
						imgBox.classList.add(uiconf.styleError);
					}else{
						imgBox.classList.add(uiconf.styleError);
						imgBox.classList.add(uiconf.styleErrorSmall);
					}
				}else{
					if(imgBox && imgBox.classList){
						imgBox.classList.add(uiconf.styleError);
					}
				}
			}
		});
	};

	var listener = {
		trigger : function(type, rs){
			if(type === 'img-load'){
				loadImg(rs);
			}
		}
	};

	window.imgBox = {
		init : function(options){
			options = options || {};
			for(var key in options){
				uiconf[key] = options[key];
			}
		}
	};
	
	window.listener = window.listener || listener;

})();


