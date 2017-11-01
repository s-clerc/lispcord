(in-package :lispcord.core)


(defstruct (bot (:constructor primitive-make-bot))
  (token "" :type string :read-only t)
  (version "0.0.1" :type string)
  (seq 0 :type fixnum)
  (session-id nil :type (or null string))
  conn
  (callbacks (make-hash-table) :type hash-table)
  heartbeat-thread)



(defparameter bot-url "N/A")
(defun bot-url (url)
  (setf bot-url url))


(defun user-agent (bot)
  (str-concat "DiscordBot (" bot-url ", " (bot-version bot) ")"))

(defun headers (bot)
  (list (cons "Authorization" (str-concat "Bot " (bot-token bot)))
        (cons "User-Agent" (user-agent bot))))




(defun discord-req (endpoint &key bot content (type :get)
		    &aux (url (str-concat +base-url+ endpoint)))
  (dprint :debug "~&HTTP-~a-Request to: ~a~%~@[  content: ~a~%~]"
	  type url content)
  (let ((final (rl-buffer endpoint)))
    (multiple-value-bind (b sta headers u str)
	(dex:request url
		     :method type
		     :headers (if bot (headers bot))
		     :content content)
      (rl-parse final headers)
      (values b sta headers u str))))

(defun get-rq (endpoint &optional bot)
  (discord-req endpoint :bot bot :type :get))

(defun post-rq (endpoint &optional bot content)
  (discord-req endpoint :bot bot :content content :type :post))


