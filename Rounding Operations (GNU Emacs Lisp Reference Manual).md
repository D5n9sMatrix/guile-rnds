<!DOCTYPE html>
<!-- saved from url=(0082)https://www.gnu.org/software/emacs/manual/html_node/elisp/Rounding-Operations.html -->
<html><!-- Created by GNU Texinfo 7.0.3, https://www.gnu.org/software/texinfo/ --><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<title>Rounding Operations (GNU Emacs Lisp Reference Manual)</title>

<meta name="description" content="Rounding Operations (GNU Emacs Lisp Reference Manual)">
<meta name="keywords" content="Rounding Operations (GNU Emacs Lisp Reference Manual)">
<meta name="resource-type" content="document">
<meta name="distribution" content="global">
<meta name="Generator" content="makeinfo">
<meta name="viewport" content="width=device-width,initial-scale=1">

<link rev="made" href="mailto:bug-gnu-emacs@gnu.org">
<link rel="icon" type="image/png" href="https://www.gnu.org/graphics/gnu-head-mini.png">
<meta name="ICBM" content="42.256233,-71.006581">
<meta name="DC.title" content="gnu.org">
<style type="text/css">
@import url('/software/emacs/manual.css');
</style>
</head>

<body lang="en">
<div class="section-level-extent" id="Rounding-Operations">
<div class="nav-panel">
<p>
Next: <a href="https://www.gnu.org/software/emacs/manual/html_node/elisp/Bitwise-Operations.html" accesskey="n" rel="next">Bitwise Operations on Integers</a>, Previous: <a href="https://www.gnu.org/software/emacs/manual/html_node/elisp/Arithmetic-Operations.html" accesskey="p" rel="prev">Arithmetic Operations</a>, Up: <a href="https://www.gnu.org/software/emacs/manual/html_node/elisp/Numbers.html" accesskey="u" rel="up">Numbers</a> &nbsp; [<a href="https://www.gnu.org/software/emacs/manual/html_node/elisp/index.html#SEC_Contents" title="Table of contents" rel="contents">Contents</a>][<a href="https://www.gnu.org/software/emacs/manual/html_node/elisp/Index.html" title="Index" rel="index">Index</a>]</p>
</div>
<hr>
<h3 class="section" id="Rounding-Operations-1">3.7 Rounding Operations</h3>
<a class="index-entry-id" id="index-rounding-without-conversion"></a>

<p>The functions <code class="code">ffloor</code>, <code class="code">fceiling</code>, <code class="code">fround</code>, and
<code class="code">ftruncate</code> take a floating-point argument and return a floating-point
result whose value is a nearby integer.  <code class="code">ffloor</code> returns the
nearest integer below; <code class="code">fceiling</code>, the nearest integer above;
<code class="code">ftruncate</code>, the nearest integer in the direction towards zero;
<code class="code">fround</code>, the nearest integer.
</p>
<dl class="first-deffn first-defun-alias-first-deffn">
<dt class="deffn defun-alias-deffn" id="index-ffloor"><span class="category-def">Function: </span><span><strong class="def-name">ffloor</strong> <var class="def-var-arguments">float</var><a class="copiable-link" href="https://www.gnu.org/software/emacs/manual/html_node/elisp/Rounding-Operations.html#index-ffloor"> ¶</a></span></dt>
<dd><p>This function rounds <var class="var">float</var> to the next lower integral value, and
returns that value as a floating-point number.
</p></dd></dl>

<dl class="first-deffn first-defun-alias-first-deffn">
<dt class="deffn defun-alias-deffn" id="index-fceiling"><span class="category-def">Function: </span><span><strong class="def-name">fceiling</strong> <var class="def-var-arguments">float</var><a class="copiable-link" href="https://www.gnu.org/software/emacs/manual/html_node/elisp/Rounding-Operations.html#index-fceiling"> ¶</a></span></dt>
<dd><p>This function rounds <var class="var">float</var> to the next higher integral value, and
returns that value as a floating-point number.
</p></dd></dl>

<dl class="first-deffn first-defun-alias-first-deffn">
<dt class="deffn defun-alias-deffn" id="index-ftruncate"><span class="category-def">Function: </span><span><strong class="def-name">ftruncate</strong> <var class="def-var-arguments">float</var><a class="copiable-link" href="https://www.gnu.org/software/emacs/manual/html_node/elisp/Rounding-Operations.html#index-ftruncate"> ¶</a></span></dt>
<dd><p>This function rounds <var class="var">float</var> towards zero to an integral value, and
returns that value as a floating-point number.
</p></dd></dl>

<dl class="first-deffn first-defun-alias-first-deffn">
<dt class="deffn defun-alias-deffn" id="index-fround"><span class="category-def">Function: </span><span><strong class="def-name">fround</strong> <var class="def-var-arguments">float</var><a class="copiable-link" href="https://www.gnu.org/software/emacs/manual/html_node/elisp/Rounding-Operations.html#index-fround"> ¶</a></span></dt>
<dd><p>This function rounds <var class="var">float</var> to the nearest integral value,
and returns that value as a floating-point number.
Rounding a value equidistant between two integers returns the even integer.
</p></dd></dl>

</div>





</body></html>