;; path（パスを通します。この下に追加した*.elを置きます）
(setq load-path (cons "~/.emacs.d/elisp" load-path))

;;browse-kill-ring
(require 'browse-kill-ring)
(global-set-key (kbd "C-c k") 'browse-kill-ring)

;;magit
(add-to-list 'load-path "~/.emacs.d/elisp/magit")
(require 'magit)

;;メニューに「最近開いたファイル」を追加する(M-x recentf-open-files)
(recentf-mode 1)
(setq recentf-max-menu-items 20) ;表示件数
(setq recentf-max-saved-items 100) ;保存件数

;;ミニバッファの入力履歴をインクリメンタルサーチできる(C-r)
(require 'minibuf-isearch)
;;ミニバッファ履歴や kill-ringを次回起動時に復元
(require 'session)
(add-hook 'after-init-hook 'session-initialize)
;;session.elの設定
(setq history-length 200) ;; そもそものミニバッファ履歴リストの最大長
(setq session-initialize '(de-saveplace session keys menus places)
      session-globals-include '((kill-ring 50)             ;; kill-ring の保存件数
                                (session-file-alist 50 t)  ;; カーソル位置を保存する件数
                                (file-name-history 200)))  ;; ファイルを開いた履歴を保存する件数

;; 保存しないファイルの正規表現;M-x desktop-save
(setq desktop-files-not-to-save "\\(^/[^/:]*:\\|\\.diary$\\)")
(autoload 'desktop-save "desktop" nil t)
(autoload 'desktop-clear "desktop" nil t)
(autoload 'desktop-load-default "desktop" nil t)
(autoload 'desktop-remove "desktop" nil t)
;;autosave autoload
(desktop-load-default)
(desktop-read)

;;キーバインド変更　Cｰhをbackspaceに
(global-set-key "\C-h" 'delete-backward-char)

;; cua-modeの設定
(cua-mode t)  ; cua-modeをオン
(setq cua-enable-cua-keys nil)  ; CUAキーバインドを無効化

;;クリップボードにコピー
(cond (window-system
(setq x-select-enable-clipboard t)
))

;;install-elisp
;; まず、install-elisp のコマンドを使える様にします。
(require 'install-elisp)
;; 次に、Elisp ファイルをインストールする場所を指定します。
(setq install-elisp-repository-directory "~/.emacs.d/elisp/")

;;auto-install.el
(require 'auto-install)
(setq auto-install-directory "~/.emacs.d/elisp/")
(auto-install-update-emacswiki-package-name t)
(auto-install-compatibility-setup)             ; 互換性確保

;;menu-tree
(require 'menu-tree)

;;; Localeに合わせた環境の設定
(set-locale-environment nil)

;; オートコンプリートモードON
;(require 'auto-complete)
(require 'auto-complete-config)
(global-auto-complete-mode t)

;;html-helper-mode
(autoload 'html-helper-mode "html-helper-mode" "Yay HTML" t)
(setq auto-mode-alist (cons '("\\.html$" . html-helper-mode) auto-mode-alist))

;;各モードと拡張子の対応
(setq auto-mode-alist
      (append
       '(
	 ("\\.h$"    . c++-mode)
	 ("\\.hpp$"  . c++-mode)
	 ("\\.txt$"  . text-mode)
	 ("\\.message$" . text-mode)
	 ("\\.htm" . html-helper-mode)
	 ("\\.shtml$" . html-helper-mode)
	 ("\\.tpl" . html-helper-mode)
	 ) auto-mode-alist))

;;どのモードのときにAC-modeにするか
(when (boundp 'ac-modes)
  (setq ac-modes
    (append ac-modes
      (list 'php-mode
	    'javascript-mode
	    'css-mode
	    'smarty-mode
	    'html-helper-mode
	    'html-mode
	    'text-mode
	    'C++-mode
	    )
      )
    )
  )

;; ------------------------------------------------------------------------
;; @ tabbar.el

;; タブ化
;; http://www.emacswiki.org/emacs/tabbar.el
;;(require 'cl)
(require 'tabbar)
(tabbar-mode)

;;グループを使わない（1.3 とやり方が違う）
(setq tabbar-buffer-groups-function nil)

;;左側のボタンを消す（これも 1.3 と違う）
(dolist (btn '(tabbar-buffer-home-button
               tabbar-scroll-left-button
               tabbar-scroll-right-button))
  (set btn (cons (cons "" nil)
                 (cons "" nil))))

;; Ctrl-Tab, Ctrl-Shift-Tab でタブを切り替える
(dolist (func '(tabbar-mode tabbar-forward-tab tabbar-forward-group tabbar-backward-tab tabbar-backward-group))
  (autoload func "tabbar" "Tabs at the top of buffers and easy control-tab navigation"))
(defmacro defun-prefix-alt (name on-no-prefix on-prefix &optional do-always)
  `(defun ,name (arg)
     (interactive "P")
     ,do-always
     (if (equal nil arg)
         ,on-no-prefix
       ,on-prefix)))
(defun-prefix-alt shk-tabbar-next (tabbar-forward-tab) (tabbar-forward-group) (tabbar-mode 1))
(defun-prefix-alt shk-tabbar-prev (tabbar-backward-tab) (tabbar-backward-group) (tabbar-mode 1))
(global-set-key [(control tab)] 'shk-tabbar-next)
(global-set-key [(control shift iso-lefttab)] 'shk-tabbar-prev)

;; GUIで直接ファイルを開いた場合フレームを作成しない
(add-hook 'before-make-frame-hook
          (lambda ()
            (when (eq tabbar-mode t)
              (switch-to-buffer (buffer-name))
              (delete-this-frame))))
;; ------------------------------------------------------------------------