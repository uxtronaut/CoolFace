class AppDelegate
  def applicationDidFinishLaunching(notification)
    @statusBar = NSStatusBar.systemStatusBar

    @faces = YAML.load(File.open(File.join(NSBundle.mainBundle.resourcePath, 'faces.yml')).read)['faces']

    @item = @statusBar.statusItemWithLength(-1)
    @item.retain
    @item.setTitle("(◕‿◕)")
    @item.setHighlightMode(true)
    @item.setMenu(setupMenu)

    center = DDHotKeyCenter.sharedHotKeyCenter

    center.registerHotKeyWithKeyCode(KVK_ANSI_C, modifierFlags:(NSCommandKeyMask|NSControlKeyMask|NSShiftKeyMask), target:self, action:'copyCoolFace:', object:nil)

  end

  def setupMenu
    menu = NSMenu.new
    menu.initWithTitle 'Menubar App'

    mi = NSMenuItem.new
    mi.title = 'Quit'
    mi.action = 'terminate:'
    menu.addItem mi

    menu
  end

  def copyCoolFace(event)

    face = @faces.shuffle.first

    %x[printf "#{face}" | __CF_USER_TEXT_ENCODING=$UID:0x8000100:0x8000100 pbcopy]
    @item.setTitle(face)
  end

end
