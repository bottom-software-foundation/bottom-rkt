#!/usr/bin/env racket
#lang racket

(define (bottomify-byte n v)
  (cond
    [(= n 0) (if (= (string-length v) 0) "❤️" (string-append v "👉👈"))]
    [(>= n 200) (bottomify-byte (- n 200) (string-append v "🫂"))]
    [(>= n 50) (bottomify-byte (- n 50) (string-append v "💖"))]
    [(>= n 10) (bottomify-byte (- n 10) (string-append v "✨"))]
    [(>= n 5) (bottomify-byte (- n 5) (string-append v "🥺"))]
    [(>= n 1) (bottomify-byte (- n 1) (string-append v ","))]
    [else ""]))

(define (bottomify port v)
  (if (eof-object? (peek-byte port)) v
      (bottomify port (string-append v (bottomify-byte (read-byte port) "")))))

(define (regress lst v acc)
  (if (null? lst) v
      (let ((c (car lst)))
      (cond
        [(char=? c #\❤) (regress (cdr lst) (bytes-append v "\000") 0)]
        [(char=? c #\🫂) (regress (cdr lst) v (+ acc 200))]
        [(char=? c #\💖) (regress (cdr lst) v (+ acc 50))]
        [(char=? c #\✨) (regress (cdr lst) v (+ acc 10))]
        [(char=? c #\🥺) (regress (cdr lst) v (+ acc 5))]
        [(char=? c #\,) (regress (cdr lst) v (+ acc 1))]
        [(char=? c #\👉) (regress (cdr lst) (bytes-append v (bytes acc)) 0)]
        [else (regress (cdr lst) v acc)]))))

(define (acc-args args)
  (cond [(null? args) ""] [(null? (cdr args)) (car args)] [else (string-append (car args) " " (acc-args (cdr args)))]))

(define should-bottomify (make-parameter #t))
(define dump-version (make-parameter #f))
(define input-source (make-parameter ""))
(define output-sink (make-parameter ""))
(define cmd-source (make-parameter ""))

(define command-parse
  (command-line
   #:program "bottom"
   #:once-each
   [("-i" "--input") INPUT "Input file [Default: command line, use - for stdin]" (input-source INPUT)]
   [("-o" "--output") OUTPUT "Output file [Default: stdout]" (output-sink OUTPUT)]
   #:once-any
   [("-b" "--bottomify") "Translate bytes to bottom"
                          (should-bottomify #t)]
   [("-r" "--regress")   "Translate bottom to human-readable text (futile)"
                          (should-bottomify #f)]
   [("-V" "--version")   "Print version"
                          (dump-version #t)]

   #:args text (cmd-source text)))




(module* main #f
  ;(printf "Output: ~a\n" (bottomify #"Hello, world!" "" 0))
  (define out (if (equal? (output-sink) "") (current-output-port) (open-output-file (output-sink))))
  (define in (cond
               [(equal? (input-source) "") (open-input-string (acc-args (cmd-source)))]
               [(equal? (input-source) "-") (current-input-port)]
               [else (open-input-file (input-source))]))
  (cond
    [(dump-version) (display "Version 1.0.0")]
    [(should-bottomify) (display (bottomify in "") out)]
    [else (display (regress (port->list read-char in) #"" 0) out)])
  (close-output-port out)
  (close-input-port in)
)
