;; path（パスを通します。この下に追加した*.elを置きます）
(setq load-path (cons "~/.emacs.d/elisp" load-path))

;; まず、install-elisp のコマンドを使える様にします。
(require 'install-elisp)
;; 次に、Elisp ファイルをインストールする場所を指定します。
(setq install-elisp-repository-directory "~/.emacs.d/elisp/")

;;menu-tree
(require 'menu-tree)

;;; Localeに合わせた環境の設定
(set-locale-environment nil)

;;auto-complete
(require 'auto-complete)
(require 'auto-complete-config)    ; 必須ではないですが一応
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
	 ("\\.php" . html-helper-mode)
	 ) auto-mode-alist))

