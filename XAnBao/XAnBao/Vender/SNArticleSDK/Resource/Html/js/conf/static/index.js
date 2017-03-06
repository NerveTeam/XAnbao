/**
 * @fileoverview 正文页具体业务逻辑代码
 * @authors xiaoyue3 <xiaoyue3@staff.sina.com.cn>
 */

var scope = {
	AP : Array.prototype,
	delegate : (function(){
		//代理事件处理的封装
		var touchMoved = false;
		var timeStart = null;
		var startPos = null;
		var onStart = function(evt){
			evt = evt.touches ? evt.touches[0] : evt;
			startPos = {
				x : evt.clientX,
				y : evt.clientY
			};
			timeStart = new Date() - 0;
		};
		var onMove = function(evt){
			evt = evt.touches ? evt.touches[0] : evt;
			var delta = {
				x : evt.clientX - startPos.x,
				y : evt.clientY - startPos.y
			};
			if(Math.abs(delta.x) >= 15 || Math.abs(delta.y) >= 15){
				touchMoved = true;
			}
		};
		var onEnd = function(evt){
			setTimeout(function(){
				startPos = null;
				timeStart = null;
				touchMoved = false;
			});
		};

		var occurInside = function(evt, node){
			if(!evt){return false;}
			var target = evt.target;
			while(target){
				if(target === node){
					break;
				}
				target = target.parentNode;
			}
			return !!target;
		};

		var checkEvent = function(eventType, evt){
			var type = '';
			if(eventType === 'tap'){
				type = 'touchend';
			}
			else{
				type = eventType;
			}
			if(!evt){
				return type;
			}else{
				if(eventType === 'tap'){
					return (!touchMoved && (new Date() - timeStart < 500) );
				}else{
					return true;
				}
			}
		};

		document.addEventListener('touchstart', onStart, false);
		document.addEventListener('touchmove', onMove, false);
		document.addEventListener('touchend', onEnd, false);

		return function(node, selector, eventType, fn){
			if(!node){return;}
			if(typeof(node.querySelectorAll) !== 'function'){return;}
			node.addEventListener(checkEvent(eventType), function(evt){
				var elements = node.querySelectorAll(selector);
				elements = scope.AP.slice.call(elements);
				elements.forEach(function(el){
					if(occurInside(evt, el)){
						evt.curTarget = el;
						if(checkEvent(eventType, evt)){
							fn(evt);
						}
					}
				});
			}, false);
		};
	})(),
	each : function(object, fn, context){
		var key;
		object = object || {};
		for(key in object){
			fn.call(context, object[key], key);
		}
	},
	append : function(){
		var args = scope.AP.slice.call(arguments);
		var original = args.shift() || {};
		args.forEach(function(item){
			item = item || {};
			scope.each(item, function(val, key){
				original[key] = val;
			});
		});
		return original;
	}
};

// 听新闻模块
;(function(){
	//音频播放组件
	var AudioPlayer = (function(){
		var Player = function(options){
			options = options || {};
			var root = this.root = options.root;
			var nodes = this.nodes = {};
			this.conf = scope.append({
				'tipLoading' : '加载中...',
				'tipError' : '失败了，请检查网络',
				'styleError' : 'listennews listennews_play error_message',
				'stylePlay' : 'listennews listennews_play',
				'stylePause' : 'listennews listennews_pause'
			},options);
			if(!root){return;}
			this.roles = scope.append({
				'audio' : 'audio',
				'box' : '[data-role="box"]',
				'button' : '[data-role="button"]',
				'time' : '[data-role="time"]',
				'error' : '[data-role="error"]',
				'state' : '[data-role="state"]'
			}, options.roles);
			scope.each(this.roles, function(selector, key){
				nodes[key] = root.querySelectorAll(selector)[0];
			});

			this.id = root.id;
			this.state = '';
			this.setEvents();
		};

		Player.prototype = {
			proxy : function(name){
				var that = this;
				var bound = this.bound ? this.bound : this.bound = {};
				name = name || 'proxy';
				if(!bound[name]){
					bound[name] = function(){
						if(typeof that[name] === 'function'){
							return that[name].apply(that, arguments);
						}
					};
				}
				return bound[name];
			},
			setEvents : function(){
				var root = this.root;
				var nodes = this.nodes;
				var proxy = this.proxy();
				scope.delegate(root, '[data-role="button"]', 'tap', proxy('toggle'));
				if(nodes.audio){
					nodes.audio.addEventListener('progress', proxy('onProgress'), false);
					nodes.audio.addEventListener('ended', proxy('reset'), false);
					nodes.audio.addEventListener('error', proxy('onError'), false);
				}
			},
			play : function(){
				var nodes = this.nodes;
				this.state = 'playing';
				if(nodes.audio){
					if(nodes.audio.error){
						nodes.audio.load();
					}
					nodes.audio.play();
				}
				this.render();
				this.watch();
			},
			pause : function(){
				var nodes = this.nodes;
				this.state = 'pause';
				if(nodes.audio){
					nodes.audio.pause();
					if(nodes.audio.error){return;}
				}
				this.render();
				this.unWatch();
			},
			isPlaying : function(){
				return this.state === 'playing';
			},
			reset : function(){
				var nodes = this.nodes;
				this.pause();
				this.state = '';
				this.render();
				if(nodes.audio){
					nodes.audio.currentTime = 0;
				}
				this.renderTime();
			},
			render : function(){
				var nodes = this.nodes;
				var state = this.state;
				var conf = this.conf;
				var config = $CONFIG || {};
				if(nodes.error){
					nodes.error.innerHTML = '';
				}
				if(nodes.box){
					nodes.box.className = state === 'playing' ? conf.stylePause : conf.stylePlay ;
				}
				if(nodes.state && config.platform === 'android' && state === 'playing'){
					//部分android机型，切换gif显示后，不触发重绘，gif不执行动画
					//这里特地触发一次重绘
					window.scrollTo(0, document.body.scrollTop + 1);
				}
			},
			toggle : function(){
				if(this.state === 'playing'){
					this.pause();
				}else{
					this.play();
				}
			},
			onError : function(evt){
				var nodes = this.nodes;
				var state = this.state;
				var conf = this.conf;
				this.pause();
				if(nodes.audio && nodes.audio.readyState){
					nodes.audio.currentTime = 0;
				}
				this.renderTime();
				if(nodes.error){
					nodes.error.innerHTML = conf.tipError;
				}
				if(nodes.box){
					nodes.box.className = conf.styleError;
				}
			},
			onProgress : function(evt){
				var nodes = this.nodes;
				var conf = this.conf;
				if(!nodes.audio){return;}
				var readyState = nodes.audio.readyState;
				if(this.state === 'playing'){
					if(nodes.box){
						if(readyState){
							this.renderTime();
						}else{
							this.setLoading();
						}
					}
				}else{
					if(readyState){
						this.init();
					}
				}
			},
			init : function(){
				if(!this.inited){
					this.inited = true;
					this.renderTime();
				}
			},
			watch : function(){
				var config = $CONFIG || {};
				//android机型计时器有可能不准，导致2秒更新一次时间
				//因此提升android机型中对事件的监控频率
				var duration = config.platform === 'android' ? 100 : 1000;
				if(!this.timer){
					this.timer = setInterval(this.proxy('renderTime'), duration);
				}
			},
			unWatch : function(){
				clearInterval(this.timer);
				this.timer = null;
			},
			setLoading : function(){
				var nodes = this.nodes;
				if(nodes.time){
					nodes.time.innerHTML = this.conf.tipLoading;
				}
			},
			renderTime : function(time){
				var nodes = this.nodes;
				if(!nodes.audio){return;}
				if(!nodes.audio.readyState){
					this.setLoading();
					return;
				}
				if(!nodes.audio.duration){
					return;
				}
				time = typeof time === 'undefined' ? nodes.audio.currentTime : time;
				time = time || 0;
				var countDown = nodes.audio.duration - time;
				var minute = parseInt(countDown / 60, 10) || 0;
				var second = parseInt(countDown % 60, 10) || 0;
				minute = minute >= 10 ? minute : "0" + minute;
				second = second >= 10 ? second : "0" + second;
				if(nodes.time){
					nodes.time.innerHTML = minute + ':' + second;
				}
			}
		};

		return Player;
	})();

	var nodes = document.querySelectorAll('[data-pl="audio-player"]');
	var players = [];
	scope.AP.slice.call(nodes).forEach(function(node){
		var player = new AudioPlayer({
			root : node
		});
		players.push(player);
	});

	var getPlayer = function(id){
		var player;
		if(id){
			players.forEach(function(item){
				if(id === item.id){
					player = item;
					return false;
				}
			});
		}else{
			player = players[0];
		}
		return player;
	};

	var sinaAudio = {
		isPlaying : function(id){
			var player = getPlayer(id);
			if(player){
				return player.isPlaying();
			}
		},
		play : function(id){
			var player = getPlayer(id);
			if(player){
				player.play();
			}
		},
		reset : function(id){
			var player = getPlayer(id);
			if(player){
				player.reset();
			}
		},
		pause : function(id){
			players.forEach(function(item){
				if(id){
					if(id === item.id){
						item.pause();
						return false;
					}
				}else{
					item.pause();
				}
			});
		}
	};

	window.sinaAudio = sinaAudio;

	scope.delegate(document, '.app_extension', 'touchstart', function(evt){
		if(evt && evt.curTarget){
			evt.curTarget.className = 'app_extension active';
		}
	});
	
	scope.delegate(document, '.app_extension', 'touchmove', function(evt){
		if(evt && evt.curTarget){
			evt.curTarget.className = 'app_extension';
		}
	});

	scope.delegate(document, '.app_extension', 'tap', function(evt){
		if(evt && evt.curTarget){
			var index = evt.curTarget.getAttribute('data-index');
			evt.curTarget.className = 'app_extension';
			document.location = '?SNAppExtension=' + index;
		}
	});
})();

//投票功能模块
;(function(){
	var Tpl = {
		result : [
			'{{#content}}',
			'<div class="q_title"><span class="q_img{{^status}}d{{/status}}"></span>{{title}}</div>',
			'<ul class="list2">',
				'{{#options}}',
				'<li {{^isown}}class="active"{{/isown}}>',
					'<div class="tit"><span>{{name}}</span></div>',
						'<div class="range" style="display:none;"><span class="percent{{percent}}" style="width:{{percent}}%"><em><b>{{percent}}%</b></em></span></div>',
						'<div class="icon_result">已选</div>',
					'</div>',
				'</li>',
				'{{/options}}',
			'</ul>',
			'{{/content}}',
			'{{^start}}<div class="btn_instantly">立即参与</div>{{/start}}',
			'{{^voted}}<div class="btn_partake">感谢您的参与</div>{{/voted}}'
		].join('')
	};

	var recordData;
	var voternum;
	var voteFlag;

	var Vote = (function(){
		var VoteComponent = function(options){
			options = options || {};
			var root = this.root = options.root;
			var nodes = this.nodes = {};
			if(!root){return;}
			this.roles = scope.append({
				'submitBtn' : '.btn_q',
				'result' : '.vtitle a',
				'error' : '.vote_error',
				'votenum' : '.vtitle em'
			}, options.roles);

			scope.each(this.roles, function(selector, key){
				nodes[key] = root.querySelectorAll(selector)[0];
			});

			this.id = root.id;
			this.status = '';
			this.setEvents();
		};

		VoteComponent.prototype = {
			proxy : function(name){
				var that = this;
				var bound = this.bound ? this.bound : this.bound = {};
				name = name || 'proxy';
				if(!bound[name]){
					bound[name] = function(){
						if(typeof that[name] === 'function'){
							return that[name].apply(that, arguments);
						}
					};
				}
				return bound[name];
			},
			setEvents : function(){
				var root = this.root;
				var roles = this.roles;
				var proxy = this.proxy();
				scope.delegate(root, roles.result, 'tap', proxy('checkResult'));
				scope.delegate(root, roles.submitBtn, 'tap', proxy('requestVote'));
				scope.delegate(root, 'li', 'tap', proxy('toggleStatus'));
				scope.delegate(root, '.btn_instantly', 'tap', proxy('joinVote'));
			},
			toggleStatus : function(evt){
				var that = this;
				var nodes = this.nodes;
				var root = this.root;
				that.status = 1;
				setTimeout(function(){
					var titles = document.querySelectorAll('.q_title');
					var sendData = that.validate();
					scope.AP.slice.call(titles).forEach(function(node){
						if(sendData['q_' + node.getAttribute('questionid')]){
							that.status = that.status+1;
						}
					});
					if(that.status >= titles.length){
						nodes.submitBtn.className= "btn_q";
					}else{
						nodes.submitBtn.className= "btn_q gray";
					}
				},400);
			},
			joinVote : function(){
				var root = this.root;
				var nodes = this.nodes;
				root.children[1].style.display = '';
				root.children[2].style.display = 'none';
				nodes.result.style.display = '';
			},
			validate : function(){
				var root = this.root;
				var data = {};
				var options = root.querySelectorAll('.list input');
				scope.AP.slice.call(options).forEach(function(item){
					var questionid = item.getAttribute('name');
					if(item.checked){
						var val = item.value.split('_');
						if(item.getAttribute('type') === 'radio'){
							data['q_' + questionid] = val[1];
						}else{
							data['q_' + questionid] = [];
							data['q_' + questionid].push(val[1]);
						}
					}
				});
				return data;
			},
			requestVote : function(){
				var titles = document.querySelectorAll('.q_title');
				var nodes = this.nodes;
				if(nodes.submitBtn.className != 'btn_q gray'){
					recordData = this.validate();
					//确保所有选项都被选中
					scope.AP.slice.call(titles).forEach(function(node){
						if(!!recordData['q_' + node.getAttribute('questionid')]){
							return false;
						}
					});
					if(JSON.stringify(recordData) != '{}'){
						nodes.submitBtn.className = 'btn_q';
						window.location = '?voteTag=vote&pollid=' + nodes.submitBtn.getAttribute('data') + '&' + 'formdata=' + JSON.stringify(recordData);
						voteFlag = true;
					}
				}
			},
			checkResult : function(evt){
				var root = this.root;
				if(evt && evt.curTarget){
					var target = evt.curTarget;
					if(target.innerHTML === '查看结果'){
						var nodes = this.nodes;
						window.location = '?voteTag=result&pollid='+ nodes.result.getAttribute('pollid');
					}else{
						root.children[2].style.display = 'none';
						root.children[1].style.display = '';
						target.innerHTML = '查看结果';
					}
				}
			},
			checkVoteResult : function(data){
				var root = this.root;
				var nodes = this.nodes;
				if(!root.children[2]){
					var div = document.createElement('div');
					div.innerHTML = mustache.render(Tpl.result, data);
					root.children[1].style.display = 'none';
					//插入模板数据
					root.appendChild(div);
				}else{
					root.children[2].innerHTML = mustache.render(Tpl.result, data);
					root.children[2].style.display = '';
					root.children[1].style.display = 'none';
				}
				//渲染百分比宽度设置
				var ranges = root.querySelectorAll('.range');
				scope.AP.slice.call(ranges).forEach(function(node){
					node.style.width = root.clientWidth - 112 + 'px';
					node.style.display = '';
				});
				
				nodes.votenum.innerHTML = '('+ voternum+'人参与)';

				if(voteFlag){
					nodes.result.style.display = 'none';
				}else{
					nodes.result.innerHTML = '我要投票';
				}
			},
			failure : function(data){
				//错误提示信息{msg:'投票失败'}
				var nodes = this.nodes;
				if(data && data.msg){
					nodes.error.innerHTML=data.msg;
				}else{
					nodes.error.innerHTML='系统繁忙，请稍后再试！';
				}
				nodes.error.style.display='';
			}
		};

		return VoteComponent;
	})();

	var voteNodes = document.querySelectorAll('.news_vote');
	var voteList = [];
	scope.AP.slice.call(voteNodes).forEach(function(node){
		var newVote = new Vote({
			root : node
		});
		voteList.push(newVote);
	});

	var getVote = function(id){
		var voter;
		if(id){
			voteList.forEach(function(item){
				if(id === item.id){
					voter = item;
					return false;
				}
			});
		}else{
			voter = voteList[0];
		}
		return voter;
	};

	var sinaVote = {
		result : function(data, id){
			var datas = dataConversion(data);
			var voter = getVote(id);
			if(voter){
				return voter.checkVoteResult(datas);
			}
		},
		failure : function(data, id){
			var voter = getVote(id);
			if(voter){
				return voter.failure(data);
			}
		}
	};

	window.sinaVote = sinaVote;
	//投票按钮 点击状态添加
	scope.delegate(document, '.btn_q', 'touchstart', function(evt){
		if(evt && evt.curTarget && evt.curTarget.className === 'btn_q'){
			evt.curTarget.className = 'btn_q active';
		}
	});
	
	scope.delegate(document, '.btn_q', 'touchmove', function(evt){
		if(evt && evt.curTarget && evt.curTarget.className === 'btn_q'){
			evt.curTarget.className = 'btn_q';
		}
	});

	scope.delegate(document, '.btn_instantly', 'touchstart', function(evt){
		if(evt && evt.curTarget){
			evt.curTarget.className = 'btn_instantly active';
		}
	});
	
	scope.delegate(document, '.btn_instantly', 'touchmove', function(evt){
		if(evt && evt.curTarget){
			evt.curTarget.className = 'btn_instantly';
		}
	});
	
	// ios工程师调用投票成功或失败方法示例
	// sinaVote.result(da,'test_vote');
	// sinaVote.failure({msg:'投票失败,请重试！'},'test_vote');

	//客户端返回的数据进行格式化
	function dataConversion(data){
		if(data){
			var resultData = {};
			if(voteFlag){
				resultData.start = true;
				resultData.voted = false;
			}else{
				resultData.start = false;
				resultData.voted = true;
			}
			resultData.content = [];
			var content = data.pollresult;
			voternum = data.voternum;
			content.forEach(function(item){
				var temp = {};
				temp.title = item.question;
				//1 单选 0多选
				if(item.question_state === '0'){
					temp.status = false;
				}else{
					temp.status = true;
				}
				temp.options = [];
				var opt = item.answer;
				opt.forEach(function(el){
					var tmp = {};
					tmp.name = el.name;
					tmp.percent = el.percent;
					if(recordData && recordData['q_' + item.questionid] === el.answerid.toString()){
						tmp.isown = false; //已选
					}else{
						tmp.isown = true; //未选
					}
					temp.options.push(tmp);
				});
				resultData.content.push(temp);
			});
			return resultData;
		}
	}
})();
