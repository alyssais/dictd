/* clientparse.y -- 
 * Created: Fri Jul 11 11:34:05 1997 by faith@acm.org
 * Revised: Fri Jul 11 15:03:30 1997 by faith@acm.org
 * Copyright 1997 Rickard E. Faith (faith@acm.org)
 * 
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the
 * Free Software Foundation; either version 1, or (at your option) any
 * later version.
 * 
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 675 Mass Ave, Cambridge, MA 02139, USA.
 * 
 * $Id: clientparse.y,v 1.1 1997/07/12 01:50:08 faith Exp $
 * 
 */

%{
#include "dict.h"
#define YYDEBUG 1
#define YYERROR_VERBOSE

static dictServer *s;
%}

%union {
   dictToken     token;
   lst_List      list;
}

				/* Terminals */

%token <token> '{' '}' T_SERVER T_PORT T_USER T_FILTER

%token <token>  T_STRING
%type  <list>   Server ServerList

%%

ServerList : Server { $$ = dict_Servers = lst_create(); lst_append($$, $1); }
           | ServerList Server { lst_append($1, $2); $$ = $1; }
           ;

Server : T_SERVER T_STRING
           {
	      s = xmalloc(sizeof(struct dictServer));
	      memset( s, 0, sizeof(struct dictServer));
	      s->host = $2.string;
	   }
           '{' SpecList '}' { $$ = s; }
       | T_SERVER T_STRING
           {
	      s = xmalloc(sizeof(struct dictServer));
	      memset( s, 0, sizeof(struct dictServer));
	      s->host = $2.string;
	      $$ = s;
	   }
         ;

SpecList : Spec
         | SpecList Spec
         ;

Spec : T_PORT T_STRING          { s->port = $2.string; }
     | T_USER T_STRING T_STRING { s->user = $2.string; s->secret = $3.string; }
     ;