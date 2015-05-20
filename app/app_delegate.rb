class AppDelegate
  def applicationDidFinishLaunching(notification)
    @currentFaceIndex = 0
    @faces = loadFaces
    @statusBarItem = setupStatusBarItem
    setupHotKeys
  end

  def loadFaces
    YAML.load(File.open(File.join(NSBundle.mainBundle.resourcePath, 'faces.yml')).read)['faces'].uniq!.shuffle
  end

  def setupStatusBarItem
    item = NSStatusBar.systemStatusBar.statusItemWithLength(-1)
    item.retain
    item.setTitle("(◕‿◕)")
    item.setHighlightMode(true)
    item.setMenu(setupMenu)
    item
  end

  def setupMenu
    menu = NSMenu.new
    menu.initWithTitle 'CoolFace'

    mi = NSMenuItem.new
    mi.title = 'Quit'
    mi.action = 'terminate:'
    menu.addItem mi

    menu
  end

  def setupHotKeys
    center = DDHotKeyCenter.sharedHotKeyCenter
    center.registerHotKeyWithKeyCode(KVK_ANSI_C, modifierFlags:(NSCommandKeyMask|NSControlKeyMask|NSShiftKeyMask), target:self, action:'copyNextFace:', object:nil)
    center.registerHotKeyWithKeyCode(KVK_ANSI_X, modifierFlags:(NSCommandKeyMask|NSControlKeyMask|NSShiftKeyMask), target:self, action:'copyPrevFace:', object:nil)
  end

  def copyNextFace(event)
    @currentFaceIndex += 1
    copyFace
  end

  def copyPrevFace(event)
    @currentFaceIndex -= 1
    copyFace
  end

  def copyFace
    face = @faces[@currentFaceIndex].strip
    %x[printf "#{face}" | __CF_USER_TEXT_ENCODING=$UID:0x8000100:0x8000100 pbcopy]
    @statusBarItem.setTitle(face)
  end

end
