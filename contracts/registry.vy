# @version 0.3.9

interface MonetaryPolicy:
    def rate() -> uint256: view
    def rate0() -> uint256: view

interface Controller:
    def amm() -> address: view
    def total_debt() -> uint256: view
    def admin_fees() -> uint256: view
    def monetary_policy() -> address: view

interface AMM:
    def price_oracle() -> uint256: view



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



# MonetaryPolicy
@external 
@view
def get_rate(_controller: address) -> uint256:
    """
    @notice Get the rate of a market by inputing the controller address
    @param _controller address
    """
    _m_p: address = Controller(_controller).monetary_policy()
    return MonetaryPolicy(_m_p).rate()


@external 
@view
def get_rate0(_controller: address) -> uint256: 
    """
    @notice Get the rate of a market by inputing the controller address
    @param _controller Controller address
    """
    _m_p: address = Controller(_controller).monetary_policy()
    return MonetaryPolicy(_m_p).rate0()


# AMM
@external 
@view
def get_price_oracle(_controller: address) -> uint256: 
    """
    @notice Get the oracle price of a market 
    @param _controller Controller address
    """
    _amm: address = Controller(_controller).amm()
    return AMM(_amm).price_oracle()


# Controller
@external
@view
def get_total_debt(_controller: address) -> uint256:
    return Controller(_controller).total_debt()


@external
@view
def get_admin_fees(_controller: address) -> uint256:
    """
    @notice get unclaimed admin fees of a specific controller/market
    @return unclaimed admin fees
    """
    return Controller(_controller).admin_fees()


@external
@view
def get_total_unclaimed_admin_fees() -> uint256:
    """
    @notice get unclaimed admin fees across all added markets
    @return total unclaimed admin fees
    """
    total: uint256 = 0
    n: int128 = self.n_controller
    for i in range(0, 999):
        if i < n:
            fee: uint256 = Controller(self.controller[i]).admin_fees()
            total += fee
        else:
            break
    return total



# Others
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
    @param _monetary_policy MonetaryPolicy to add
    @dev only callable by admin
    """
    assert self.admin == msg.sender, "admin only"

    self.monetary_policy[self.n_monetary_policy] = _monetary_policy
    self.n_monetary_policy += 1  
    return True


# Ownership
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
