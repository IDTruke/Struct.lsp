(defun c:test (/ var)
  (InputBox "test")
  (princ) )

(defun InputBox (titre)
  ;; Créer un fichier DCL temporaire
  (setq temp (vl-filename-mktemp "Tmp.dcl")
        file (open temp "w")
        ret  ""
  )
  ;; Ecrire le fichier
  (write-line
    (strcat
	  "InputBox
	  :dialog{
		label=\"Paramètres de la structure\";
		initial_focus=\"msg\";
		:row{
		  :boxed_column{
		    label=\"Voies\";
		        :edit_box{
		          key=\"eb1\";
		          label=\"Largeur de voie\";
		          edit_width=6;
		        }
			:slider{
			  key=\"slid1\";
			  max_value=45;
			  min_value=20;
			  value=\"30\";
			}
			:boxed_radio_row{
			  label=\"Sens\";
			  :radio_button{
			    key=\"rb11\";
			    label=\"Double\";
			    value=\"1\";
			  }
			  :radio_button{
			    key=\"rb12\";
			    label=\"Direct\";
			  }
			  :radio_button{
			    key=\"rb13\";
			    label=\"Inverse\";
			  }
			}
			:boxed_row{
			  label=\"Options\";
			  :toggle{
			    key=\"tog1\";
			    label=\"Trottoirs\";
			  }
			  :toggle{
			    key=\"tog2\";
			    label=\"Stationnement\";
			  }
			  :toggle{
			    key=\"tog3\";
			    label=\"Piste cyclable\";
			  }
			}
		  spacer; }
		}
		:row{
		  :boxed_column{
		    label=\"Trottoirs\";
		    :edit_box{
		      key=\"eb2\";
		      label=\"Largeur de trottoir\";
		      edit_width=6;
		    }
		    :slider{
		      key=\"slid2\";
		      max_value=50;
		      min_value=10;
		      value=\"15\";
		    }
		  }
		}
		:row{
		  :boxed_column{
		    label=\"Stationnement\";
		    :boxed_radio_row{
		      :radio_button{
		        key=\"rb21\";
		        label=\"Longitudinal\";
		        value=\"1\";
		      }
		      :radio_button{
		        key=\"rb22\";
		        label=\"Bataille\";
		      }
		    }
		  }
		}
		:row{
		  :boxed_column{
		    label=\"Piste cyclable\";
		    :boxed_radio_row{
		      :radio_button{
		        key=\"rb31\";
		        label=\"Piste\";
		        value=\"1\";
		      }
		      :radio_button{
		        key=\"rb32\";
		        label=\"Bande\";
		      }
		    }
		  }
		}
	  ok_cancel; }"
	)
	file
  )
  (close file)
  ;; Ouvrir la boite de dialogue
  (setq dcl_id (load_dialog temp))
  (if (not (new_dialog "InputBox" dcl_id))
    (exit)
  )
  (set_tile "eb1" "3")
  (set_tile "eb2" "1.5")
  (setq sens "double")
  (setq VoieL "3")
  (setq TrotL "1.5")
  ;si changement du slider voies
  (action_tile
    "slid1"
    "(setq VoieL $value)
    (slider1_action $value $reason)")
  (action_tile
    "eb1"
    "(setq VoieL $value)
    (ebox1_action $value $reason)")
  (action_tile "rb11" "(setq sens \"double\")")
  (action_tile "rb12" "(setq sens \"direct\")")
  (action_tile "rb13" "(setq sens \"inverse\")")
  ;si changement du slider trottoirs
  (action_tile
    "slid2"
    "(setq TrotL $value)
    (slider2_action $value $reason)")
  (action_tile
    "eb2"
    "(setq TrotL $value)
    (ebox2_action $value $reason)")
  ;action des options
  (action_tile "tog1"
    "(mode_tile \"eb2\" (nth (atoi $value) '(1 0)))
    (mode_tile \"slid2\" (nth (atoi $value) '(1 0)))")
  (action_tile "tog2"
    "(mode_tile \"rb21\" (nth (atoi $value) '(1 0)))
    (mode_tile \"rb22\" (nth (atoi $value) '(1 0)))")
  (action_tile "tog3"
    "(mode_tile \"rb31\" (nth (atoi $value) '(1 0)))
    (mode_tile \"rb32\" (nth (atoi $value) '(1 0)))")
  ;fonction slider voies
  (defun slider1_action (val why)
    (if (or (= why 2) (= why 1))
      (set_tile "eb1" (rtos (/ (atof val) 10) 2 2)) ) )
  (defun ebox1_action (val why)
    (if (or (= why 2)(= why 1))
      (set_tile "slid1" (rtos (* (atof val) 10) 2 2)) ) )
  ;fonction slider trottoirs
  (defun slider2_action (val why)
    (if (or (= why 2) (= why 1))
      (set_tile "eb2" (rtos (/ (atof val) 10) 2 2)) ) )
  (defun ebox2_action (val why)
    (if (or (= why 2)(= why 1))
      (set_tile "slid2" (rtos (* (atof val) 10) 2 2)) ) )
  ;Desactive les options
  (foreach elem '("eb2" "slid2" "rb21" "rb22" "rb31" "rb32")
    (mode_tile elem 1) )
  (defun resultats (/ truc)
    (princ) )
    
  (action_tile
    "accept"
      "(setq ret (atof (get_tile \"eb1\")))"
      "(setq (done_dialog)"
  )
  (princ (get_tile "eb1"))
  (start_dialog)
  (unload_dialog dcl_id)
  ;;Supprimer le fichier
  (vl-file-delete temp)
  ret
)

