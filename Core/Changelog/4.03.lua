local W = unpack((select(2, ...))) ---@type WindTools

W.Changelog[403] = {
	RELEASE_DATE = "TBD",
	IMPORTANT = {
		["zhCN"] = {
			"一些代码清理.",
		},
		["zhTW"] = {
			"一些代碼清理.",
		},
		["enUS"] = {
			"Some code cleanup.",
		},
		["koKR"] = {
			"일부 코드 정리.",
		},
		["ruRU"] = {
			"Некоторая очистка кода.",
		},
	},
	NEW = {
		["zhCN"] = {
			"[矩形小地图] 新增了对 HereBeDragons-Pins 插件图标的支持, 默认开启.",
		},
		["zhTW"] = {
			"[矩形小地圖] 新增了對 HereBeDragons-Pins 插件圖示的支持, 預設開啟.",
		},
		["enUS"] = {
			"[Rectangular Minimap] Add support for pins from HereBeDragons-Pins library, enabled by default.",
		},
		["koKR"] = {
			"[사각형 미니맵] HereBeDragons-Pins 플러그인 핀 지원 추가, 기본값으로 활성화.",
		},
		["ruRU"] = {
			"[Прямоугольная миникарта] Добавлена поддержка иконок из плагина HereBeDragons-Pins, включено по умолчанию.",
		},
	},
	IMPROVEMENT = {
		["zhCN"] = {
			"[美化皮肤] 优化了社区窗口的皮肤.",
			"[美化皮肤] 重写了选框皮肤, 能够更稳定的在诸如地下城选择界面等选框上应用皮肤.",
			"[美化皮肤] 选框皮肤现在可以自动应用在暴雪的设定界面中.",
			"[交接] 提升了多任务时的稳定性.",
			"[成就追踪] 支持了更多种类的奖励显示.",
			"[成就追踪] 搜索支持了奖励过滤, 比如搜索「坐骑」会显示奖励坐骑相关成就或者奖励坐骑的成就.",
			"[进度] 优化了大使任务任务进度的通报逻辑, 只会在任务进度推进时进行通报.",
			"[进度] 优化了任务完成时的通报逻辑, 避免部分任务在完成时重复通报.",
		},
		["zhTW"] = {
			"[美化皮膚] 優化了社區視窗的皮膚.",
			"[美化皮膚] 重寫了選框皮膚, 能夠更穩定的在諸如地城選擇介面等選框上應用皮膚.",
			"[美化皮膚] 選框皮膚現在可以自動應用在暴雪的設定介面中.",
			"[交接] 提升了多任務時的穩定性.",
			"[成就追蹤] 支援了更多種類的獎勵顯示.",
			"[成就追蹤] 搜尋支援了獎勵過濾, 比如搜尋「坐騎」會顯示獎勵坐騎相關成就或者獎勵坐騎的成就.",
			"[進度] 優化了大使任務任務進度的通報邏輯, 只會在任務進度推進時進行通報.",
			"[進度] 優化了任務完成時的通報邏輯, 避免部分任務在完成時重複通報.",
		},
		["enUS"] = {
			"[Skins] Optimize the skin for the Communities frame.",
			"[Skins] Rewrote the checkbox skinning to apply more reliably on checkboxes in places like the dungeon selection.",
			"[Skins] Checkbox skinning can now be applied in Blizzard's Settings.",
			"[Turn In] Improve stability when there are multiple quests.",
			"[Achievement Tracker] Support more types of reward display.",
			"[Achievement Tracker] Search supports reward filtering, for example searching for 'mount' will show achievements related to mounts or achievements that reward mounts.",
			"[Progress] Optimize the reporting logic for emissary quest progress, only reporting when quest progress updates.",
			"[Progress] Optimize the reporting logic when completing quests to avoid duplicate reports for some quests.",
		},
		["koKR"] = {
			"[스킨] 커뮤니티 창의 스킨을 최적화했습니다.",
			"[스킨] 던전 선택과 같은 곳의 체크박스에 더 안정적으로 적용할 수 있도록 체크박스 스킨을 다시 작성했습니다.",
			"[스킨] 체크박스 스킨이 이제 블리자드 설정에 적용될 수 있습니다.",
			"[퀘스트 완료] 여러 퀘스트가 있을 때 안정성을 향상시켰습니다.",
			"[업적 추적기] 더 많은 유형의 보상 표시를 지원합니다.",
			"[업적 추적기] 검색이 보상 필터링을 지원합니다. 예를 들어 '탈것'을 검색하면 탈것과 관련된 업적이나 탈것을 보상으로 주는 업적이 표시됩니다.",
			"[진행 상황] 대사관 퀘스트 진행 상황에 대한 보고 논리를 최적화하여 퀘스트 진행 상황이 업데이트될 때만 보고합니다.",
			"[진행 상황] 일부 퀘스트에 대한 중복 보고를 피하기 위해 퀘스트 완료 시 보고 논리를 최적화했습니다.",
		},
		["ruRU"] = {
			"[Скины] Оптимизирован скин для фрейма Сообщества.",
			"[Скины] Переписана система оформления флажков для более надежного применения на флажках в таких местах, как выбор подземелий.",
			"[Скины] Оформление флажков теперь может применяться в настройках Blizzard.",
			"[Сдача заданий] Повышена стабильность при наличии нескольких заданий.",
			"[Трекер достижений] Добавлена поддержка большего количества типов отображения наград.",
			"[Трекер достижений] Поиск теперь поддерживает фильтрацию по наградам, например, поиск по слову 'маунт' покажет достижения, связанные с маунтами, или достижения, награждаемые маунтами.",
			"[Прогресс] Оптимизирована логика отчетности по прогрессу заданий эмиссаров, отчеты теперь отправляются только при обновлении прогресса задания.",
			"[Прогресс] Оптимизирована логика отчетности при выполнении заданий, чтобы избежать дублирующихся отчетов для некоторых заданий.",
		},
	},
}
