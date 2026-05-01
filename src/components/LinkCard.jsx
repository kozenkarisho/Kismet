function LinkCard({ title, url, category }) {
  return (
    <div className="link-card">
      <span className="category">{category}</span>
      <h3>{title}</h3>
      <a href={url} target="_blank" rel="noopener noreferrer">
        Open Link
      </a>
    </div>
  )
}

export default LinkCard