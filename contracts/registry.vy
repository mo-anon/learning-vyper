# @version 0.3.9

interface MonetaryPolicy:
    def rate() -> uint256: view
    
interface Controller:
    def total_debt() -> uint256: view
    def admin_fees() -> uint256: view


admin: public(address)

controller: public(HashMap[int128, address])
amm: public(HashMap[int128, address])
monetary_policy: public(HashMap[int128, address])

n_controller: public(int128)
n_amm: public(int128)
n_monetary_policy: public(int128)

@external
def __init__():
    self.admin = msg.sender
    self.n_controller = 0
    self.n_amm = 0
    self.n_monetary_policy = 0


@external 
@view
def get_rate(_monetary_policy: address) -> uint256: 
    return MonetaryPolicy(_monetary_policy).rate()

@external
@view
def get_admin_fees(_controller: address) -> uint256:
    return Controller(_controller).admin_fees()




@external
def add_controller(_controller: address) -> bool:
    """
    @notice Function to add a new controller contract
    @param _controller Controller to add
    @dev only callable by admin
    """

    assert self.admin == msg.sender, "admin only"

    self.controller[self.n_controller] = _controller  
    self.n_controller += 1  
    return True


@external
def add_amm(_amm: address) -> bool:
    """
    @notice Function to add a new amm contract
    @param _amm AMM to add
    @dev only callable by admin
    """
    assert self.admin == msg.sender, "admin only"

    self.amm[self.n_amm] = _amm
    self.n_amm += 1  
    return True

@external
def add_monetary_policy(_monetary_policy: address) -> bool:
    """
    @notice Function to add a new monetary policy contract
    @param _controller MonetaryPolicy to add
    @dev only callable by admin
    """
    assert self.admin == msg.sender, "admin only"

    self.monetary_policy[self.n_monetary_policy] = _monetary_policy
    self.n_monetary_policy += 1  
    return True



@external
def set_admin(_admin: address) -> bool:
    """
    @notice Function to set a new admin address
    @param _admin New Admin
    @dev only callable by admin
    """
    assert self.admin == msg.sender, "admin only"
    self.admin = _admin
    return True
