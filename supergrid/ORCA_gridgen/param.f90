MODULE param
  USE kinds
! many of these parameters could be moved to a namelist,
! with the rest derived from them
!!----------------------------------------------------------------------
!! Software governed by the CeCILL licence (modipsl/doc/NEMO_CeCILL.txt)
!!----------------------------------------------------------------------


  IMPLICIT NONE

  !!----------------------------------------------------------------------
  !! 
  !! 	parameter module    : demi-grille nord
  !!    : parameters for the north half-grid (spans 180 degrees longitude)
  !! 
  !!----------------------------------------------------------------------
  !!
  !! Controle parameter:
  !! -------------------
  !!  l_nth_calc:  TRUE => calculate the north grid (the slow bit)
  !!               FALSE=> read the north grid from file
  !!
  !!  l_e1_calc:  TRUE => calculate everything
  !!              FALSE=> skip zonal scale factors (~ 5x faster for testing)
  !!
  !!  l_trop_stretch:  TRUE => Increase meridional resolution in tropics
  !!                   FALSE=> Leave mercator resolution set by msh_sth
  !!
  !!  l_write_binary:  old style binary file for north grid
  !!
  !!	  ncompt: nombre d iteration pour la methode de dicotomie
  !!
  !!      ndebug: Controle les impressions pour le debuggage
  !! (ATTENTION NDEBUG>=2 les impressions sont enormes, la taille des ma-
  !!  ne doit pas exceder quelques dizaines par quelques dizaines)

  LOGICAL, PARAMETER :: l_nth_calc = .TRUE.
  LOGICAL, PARAMETER :: l_e1_calc = .TRUE.
  LOGICAL, PARAMETER :: l_trop_stretch = .FALSE.
  LOGICAL, PARAMETER :: l_write_binary = .FALSE.
  INTEGER :: ndebug = 0
  INTEGER :: ncompt

  !!-------------------------------------------------------------------
  !!
  !! Grille globale modele:
  !! ----------------------
  !!      jpeq	: Position de l equateur de la grille
  !!                (en nb de pts de grille determine par carac.F)
  !!	jpeqt	: Position de l equateur Terrestre de la grille globale
  !!                (en nb de pts de grille determine par carac.F)
  !!      jpnord	: Nb de points grille dans la partie nord (equateur de
  !!                la grille inclu)
  !!	jpnp	: Position de la variation des facteurs d echelle
  !!		  au voisinage (neigbouring) du pole nord geographique
  !!	jpi     : Nb de pts de grille zonal de la grille globale
  !!      jpj     : Nb de pts de grille meridien de la grille globale
  !!		  (le -1 vient du fait que l Equateur est compte 2 fois,
  !!		   dans jpeq et dans jpnord)
  !!             (doesn't include tropical stretching)
  !!
  !! ATTENTION : JPI n est pas idependant et est fonction de RPHIEQS et
  !!             JPEQ
  !! 1x1 degree
  INTEGER, PARAMETER :: &!:
       jpi    =  1440+1        ,&
       jpeqt  =  800+1          ,&  ! From south to equator
       jpeqn  =  80           ,&  ! From equator to join
       jpnord =  440+1              ! From join to top

  INTEGER, PARAMETER :: &!:
       jpeq   =  jpeqt+jpeqn    ,&  ! From south to join
       jpj    =  jpeq+jpnord-1  ,&  ! Whole grid
       jpnp   =  jpnord       
  !!
  !!----------------------------------------------------------------------
  !!
  !! Demi grille nord (tout points)
  !! ---------------------------
  !!	jpin	: = jpi, nb de meridiens de la demi grille nord incluant 
  !!	          les 2 meridiens passant par chaque pole
  !!	jpjn	: = 2*jpjnord, nb de parallele de la demi grille nord 
  !!	          incluant la ligne equateur de la grille (ligne T-U) et 
  !!	          la ligne pole (ligne V-F)
  !!

  INTEGER, PARAMETER :: jpin = jpi , jpjn = 2*jpnord

  !!
  !!----------------------------------------------------------------------
  !!
  !! Accroissement de resolution pour les calculs
  !! -----------------------------------------
  !!	jpfac   : facteur de resolution demi-grille nord/grille fine
  !!	          servant au calcul des facteurs d echelle
  !!	jpint   : facteur de resolution grille fine/pas de resolution
  !!		  de l eq. differentielle
  !!

  INTEGER, PARAMETER :: jpfac = 5 , jpint = 10

  !!
  !!----------------------------------------------------------------------
  !!
  !! Demi grille nord fine:
  !! ----------------------
  !!      jpjf    : nb de pts par courbe de "longitude" (grille fine)
  !!                (=Nb de cercles de "latitude"=cste) servant pour le 
  !!                 calcul des facteurs d echelle (jpfac fois + de
  !!		   resolution que la demi grille nord)
  !!      jph     : nombre de point sur lequel se fait la resolution nume-
  !!                rique de l equation differentielle (jpint fois + de
  !!                resolution que la grille fine).
  !!

  INTEGER, PARAMETER :: jpjf = jpfac*(jpjn-1)+1 ,  jph = jpint*(jpjf-1)+1

  !! 
  !!----------------------------------------------------------------------
  !!
  !! PARAMETER  dimension de la global mesh avec cl east-west and north
  !!
  !!      jpim    : jpi+1  (condition de periodicite east-west)
  !!      jpim    : jpj+1  (condition de repliement nord)
  !!

  INTEGER, PARAMETER :: jpim = jpi+1, jpjm = jpj+1

  !!
  !!----------------------------------------------------------------------
  !!
  !! PARAMETER  dimension de la global mesh pour les traces graphics ncar
  !!
  !!      jpiglo  : jpi+1  (condition de periodicite east-west)
  !!      jpiglo  : jpj+1  (condition de repliement nord)
  !!

  INTEGER, PARAMETER :: jpiglo = jpi+1, jpjglo = jpj+1

  !!
  !!----------------------------------------------------------------------


  !! COMMON comcst: constantes physiques
  !! -----------------------------------
  !!      rzero   : Zero machine
  !!      rpi     : pi=3,1415....
  !!      rad     : Conversion degre ==> radian
  !!      ra      : Rayon de la terre
  !!
  !
  ! rayon de la terre
  REAL(wp), PARAMETER :: ra=6371229.0_wp
  !
  ! pi
  REAL(wp), PARAMETER :: rpi=3.141592653589793_wp
  !
  ! conversion degre radian
  REAL(wp), PARAMETER :: rad=rpi/180.0_wp
  !
  ! zero machine
  REAL(wp), PARAMETER :: rzero=1.E-14_wp
  !



END MODULE param
