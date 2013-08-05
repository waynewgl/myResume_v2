		jQuery(document).ready(function() {
			/*
			*   Examples - images
			*/

			jQuery("a#myFancybox1").fancybox();

			jQuery("a.myFancybox2").fancybox({
				'titleShow'     : true,
				'transitionIn'	: 'elastic',
				'transitionOut'	: 'elastic',
				'easingIn'      : 'easeOutBack',
				'easingOut'     : 'easeInBack'
			});

            jQuery(".myFancybox_file").fancybox({
                'titleShow'     : true,
                'transitionIn'	: 'elastic',
                'transitionOut'	: 'elastic',
                'easingIn'      : 'easeOutBack',
                'easingOut'     : 'easeInBack'
            });

			jQuery("a#myFancybox3").fancybox({
				'transitionIn'	: 'none',
				'transitionOut'	: 'none'	
			});

			jQuery("a#myFancybox4").fancybox({
				'opacity'		: true,
				'overlayShow'	: false,
				'transitionIn'	: 'elastic',
				'transitionOut'	: 'none'
			});

			jQuery("a#myFancybox5").fancybox();

			jQuery("a#myFancybox6").fancybox({
				'titlePosition'		: 'outside',
				'overlayColor'		: '#000',
				'overlayOpacity'	: 0.9
			});

			jQuery("a#myFancybox7").fancybox({
				'titlePosition'	: 'inside'
			});

			jQuery("a#myFancybox8").fancybox({
				'titlePosition'	: 'over'
			});

			jQuery("a[rel=example_group]").fancybox({
				'transitionIn'		: 'none',
				'transitionOut'		: 'none',
				'titlePosition' 	: 'over',
				'titleFormat'		: function(title, currentArray, currentIndex, currentOpts) {
					return '<span id="fancybox-title-over">Image ' + (currentIndex + 1) + ' / ' + currentArray.length + (title.length ? ' &nbsp; ' + title : '') + '</span>';
				}
			});

			/*
			*   Examples - various
			*/

			jQuery("#various1").fancybox({
				'titlePosition'		: 'inside',
				'transitionIn'		: 'none',
				'transitionOut'		: 'none'
			});

			jQuery("#various2").fancybox();

			jQuery("#various3").fancybox({
				'width'				: '75%',
				'height'			: '75%',
				'autoScale'			: false,
				'transitionIn'		: 'none',
				'transitionOut'		: 'none',
				'type'				: 'iframe'
			});

			jQuery("#various4").fancybox({
				'padding'			: 0,
				'autoScale'			: false,
				'transitionIn'		: 'none',
				'transitionOut'		: 'none'
			});
		});
